defmodule Moc.PullRequests.PullRequest do
  use Ecto.Schema

  schema "pull_requests" do
    field :external_id, :integer
    field :title, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:abandoned, :active, :all, :completed, :notSet]
    field :created_on, :utc_datetime
    field :closed_on, :utc_datetime
    field :source_branch, :string
    field :target_branch, :string
    field :is_draft, :boolean
    field :delete_source_branch, :boolean
    field :squash_merge, :boolean
    field :merge_strategy, Ecto.Enum, values: [:noFastForward, :rebase, :rebaseMerge, :squash]
    field :ready_for_use, :boolean
    field :comments_imported_on, :utc_datetime

    has_many(:comments, Moc.PullRequests.PullRequestComment)
    has_many(:reviews, Moc.PullRequests.PullRequestReview)
    belongs_to(:repository, Moc.Admin.Repository)
    belongs_to(:created_by, Moc.Contributors.Contributor)

    timestamps(type: :utc_datetime)
  end
end
