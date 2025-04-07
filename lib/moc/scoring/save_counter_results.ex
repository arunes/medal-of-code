defmodule Moc.Scoring.SaveCounterResults do
  import Moc.Utils.Date, only: [utc_now: 0]
  require Logger
  alias Moc.Repo
  alias Moc.Schema
  alias Moc.Scoring.Type

  @spec run(Type.result_set()) :: Type.result_set()
  def run(result_set) do
    Logger.info("Saving counter results for counter with id #{result_set.counter_id}")

    to_insert =
      result_set.results
      |> Enum.filter(fn r -> is_nil(r.contributor_counter_id) end)
      |> Enum.map(fn r ->
        %{
          counter_id: result_set.counter_id,
          repository_id: r.repository_id,
          contributor_id: r.contributor_id,
          count: Enum.sum_by(r.data, & &1.count),
          inserted_at: utc_now(),
          updated_at: utc_now()
        }
      end)

    Repo.insert_all(Schema.ContributorCounter, to_insert)

    # update existing
    result_set.results
    |> Enum.filter(fn r -> not is_nil(r.contributor_counter_id) end)
    |> Enum.each(fn r ->
      Repo.update(
        Ecto.Changeset.change(%Schema.ContributorCounter{id: r.contributor_counter_id},
          count: r.old_count + Enum.sum_by(r.data, & &1.count)
        )
      )
    end)

    result_set
  end
end
