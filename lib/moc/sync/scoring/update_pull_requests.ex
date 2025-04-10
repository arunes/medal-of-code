defmodule Moc.Sync.Scoring.UpdatePullRequests do
  import Moc.Utils.Date, only: [utc_now: 0]
  require Logger
  alias Moc.Repo
  alias Moc.Schema
  alias Moc.Sync.Scoring.Type

  @spec run(Type.result_set()) :: Type.result_set()
  def run(result_set) do
    Logger.info("Updating pull requests for counter with id #{result_set.counter_id}")

    to_insert =
      result_set.prs_ran_on
      |> Enum.map(fn pr_id ->
        %{
          counter_id: result_set.counter_id,
          pull_request_id: pr_id,
          inserted_at: utc_now(),
          updated_at: utc_now()
        }
      end)

    Repo.insert_all(Schema.PullRequestCounter, to_insert)
    result_set
  end
end
