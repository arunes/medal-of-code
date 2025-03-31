defmodule Moc.Db.Schema.PullRequestComment do
  use Ecto.Schema

  schema "pull_request_comments" do
    field(:external_id, :integer)
    field(:thread_id, :integer)
    field(:thread_status, :string)
    field(:parent_comment_id, :integer)
    field(:content, :string)
    field(:comment_type, :string)
    field(:liked_by, :string)
    field(:published_on, :naive_datetime)
    field(:updated_on, :naive_datetime)
    belongs_to(:created_by, Moc.Db.Schema.Contributor)
    belongs_to(:pull_request, Moc.Db.Schema.PullRequest)
    timestamps()
  end

  def changeset(pull_request_comment, params \\ %{}) do
    pull_request_comment
    |> Ecto.Changeset.cast(params, [
      :external_id,
      :thread_id,
      :thread_status,
      :parent_comment_id,
      :content,
      :comment_type,
      :liked_by,
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
