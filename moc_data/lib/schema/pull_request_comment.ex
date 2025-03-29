defmodule MocData.Schema.PullRequestComment do
  use Ecto.Schema

  schema "pull_request_comments" do
    field(:external_id, :integer)
    field(:thread_id, :integer)
    field(:parent_comment_id, :integer)
    field(:content, :string)
    field(:comment_type, :string)
    field(:published_on, :utc_datetime)
    field(:updated_on, :utc_datetime)
    belongs_to(:created_by, MocData.Schema.Contributor)
    belongs_to(:pull_request, MocData.Schema.PullRequest)
    timestamps()
  end

  def changeset(pull_request_comment, params \\ %{}) do
    pull_request_comment
    |> Ecto.Changeset.cast(params, [
      :external_id,
      :thread_id,
      :parent_comment_id,
      :content,
      :comment_type,
      :published_on,
      :updated_on,
      :created_by_id,
      :pull_request_id
    ])
    |> Ecto.Changeset.validate_required([
      :external_id,
      :thread_id,
      :parent_comment_id,
      :content,
      :comment_type,
      :published_on,
      :updated_on,
      :created_by_id,
      :pull_request_id
    ])
    |> Ecto.Changeset.assoc_constraint(:created_by)
    |> Ecto.Changeset.assoc_constraint(:pull_request)
  end
end
