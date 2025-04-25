defmodule Moc.PullRequests.PullRequestCounter do
  use Ecto.Schema

  schema "pull_request_counters" do
    belongs_to(:counter, Moc.Scoring.Counter)
    belongs_to(:pull_request, Moc.PullRequests.PullRequest)

    timestamps(type: :utc_datetime)
  end
end
