defmodule Moc.Data.Schema.PullRequest do
  alias Moc.Data.Schema.PullRequestReview
  alias Moc.Data.Schema.PullRequestComment
  use TypedEctoSchema

  typed_schema "pull_requests" do
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
    has_many(:comments, PullRequestComment)
    has_many(:reviews, PullRequestReview)
    belongs_to(:repository, Moc.Data.Schema.Repository)
    belongs_to(:created_by, Moc.Data.Schema.Contributor)
    timestamps()
  end

  def changeset(pull_request, params \\ %{}) do
    pull_request
    |> Ecto.Changeset.cast(params, [
      :external_id,
      :title,
      :description,
      :status,
      :created_on,
      :closed_on,
      :source_branch,
      :target_branch,
      :is_draft,
      :delete_source_branch,
      :squash_merge,
      :merge_strategy,
      :ready_for_use,
      :comments_imported_on,
      :repository_id,
      :created_by_id
    ])
    |> Ecto.Changeset.validate_required([
      :external_id,
      :title,
      :status,
      :created_on,
      :closed_on,
      :source_branch,
      :target_branch,
      :is_draft,
      :ready_for_use,
      :repository_id,
      :created_by_id
    ])
    |> Ecto.Changeset.assoc_constraint(:repository)
    |> Ecto.Changeset.assoc_constraint(:created_by)
  end
end
