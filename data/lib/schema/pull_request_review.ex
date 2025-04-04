defmodule Moc.Data.Schema.PullRequestReview do
  use Ecto.Schema

  schema "pull_request_reviews" do
    field(:vote, :integer)
    field(:is_required, :boolean)
    belongs_to(:reviewer, Moc.Data.Schema.Contributor)
    belongs_to(:pull_request, Moc.Data.Schema.PullRequest)
    timestamps()
  end

  def changeset(pull_request_review, params \\ %{}) do
    pull_request_review
    |> Ecto.Changeset.cast(params, [:vote, :is_required, :reviewer_id, :pull_request_id])
    |> Ecto.Changeset.validate_required([:vote, :is_required, :reviewer_id, :pull_request_id])
    |> Ecto.Changeset.assoc_constraint(:reviewer)
    |> Ecto.Changeset.assoc_constraint(:pull_request)
  end
end
