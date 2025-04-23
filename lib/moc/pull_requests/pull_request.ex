defmodule Moc.PullRequests.PullRequest do
  use Ecto.Schema

  schema "pull_requests" do
    field(:external_id, :integer)
    field(:title, :string)
    field(:description, :string)
    field(:status, :string)
    field(:created_on, :naive_datetime)
    field(:closed_on, :naive_datetime)
    field(:source_branch, :string)
    field(:target_branch, :string)
    field(:is_draft, :boolean)
    field(:delete_source_branch, :boolean)
    field(:squash_merge, :boolean)
    field(:merge_strategy, :string)
    field(:ready_for_use, :boolean)
    field(:comments_imported_on, :naive_datetime)

    # has_many(:comments, PullRequestComment)
    # has_many(:reviews, PullRequestReview)
    belongs_to(:repository, Moc.Admin.Repository)
    belongs_to(:created_by, Moc.PullRequests.Contributor)

    timestamps(type: :utc_datetime)
  end
end
