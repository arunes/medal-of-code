defmodule Moc.Repo.Migrations.CreatePullRequestComments do
  use Ecto.Migration

  def change do
    create table(:pull_request_comments) do
      add :external_id, :integer, null: false
      add :thread_id, :integer, null: false
      add :thread_status, :string, null: true
      add :parent_comment_id, :integer, null: false
      add :content, :text, null: false
      add :comment_type, :string, null: false
      add :liked_by, :string, null: false
      add :published_on, :utc_datetime, null: false
      add :updated_on, :utc_datetime, null: false
      add :created_by_id, references(:contributors, on_delete: :delete_all), null: false
      add :pull_request_id, references(:pull_requests, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index("pull_request_comments", [:pull_request_id])
    create index("pull_request_comments", [:created_by_id])
  end
end
