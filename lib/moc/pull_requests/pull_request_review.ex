defmodule Moc.PullRequests.PullRequestReview do
  use Ecto.Schema

  schema "pull_request_reviews" do
    field :vote, :integer
    field :is_required, :boolean

    belongs_to(:reviewer, Moc.PullRequests.Contributor)
    belongs_to(:pull_request, Moc.PullRequests.PullRequest)

    timestamps(type: :utc_datetime)
  end
end
