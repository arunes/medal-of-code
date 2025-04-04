defmodule Moc.Scoring.Impl.AwardXP do
  import Moc.Utils.Date, only: [utc_now: 0]
  require Logger
  alias Moc.Data.Repo
  alias Moc.Data.Schema
  alias Moc.Scoring.Type

  @spec run(Type.result_set()) :: Type.result_set()
  def run(result_set) do
    Logger.info("Awarding XP for counter with id #{result_set.counter_id}")

    to_insert =
      result_set.results
      |> Enum.flat_map(fn result ->
        result.data
        |> Enum.map(fn d ->
          %{
            contributor_id: result.contributor_id,
            pull_request_id: d.pull_request_id,
            xp: d.xp,
            dark_xp: add_dark_xp(d.affinity, d.xp),
            light_xp: add_light_xp(d.affinity, d.xp),
            dexterity: d.dexterity,
            wisdom: d.wisdom,
            charisma: d.charisma,
            constitution: d.constitution,
            inserted_at: utc_now(),
            updated_at: utc_now()
          }
        end)
      end)
      |> Enum.filter(fn d -> d.xp + d.dexterity + d.wisdom + d.charisma + d.constitution > 0 end)

    Repo.insert_all(Schema.ContributorXP, to_insert)

    result_set
  end

  defp add_dark_xp("dark", xp), do: xp
  defp add_dark_xp(_, _), do: 0.0

  defp add_light_xp("dark", xp), do: xp
  defp add_light_xp(_, _), do: 0.0
end
