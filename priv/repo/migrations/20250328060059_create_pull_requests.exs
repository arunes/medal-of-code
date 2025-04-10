defmodule Moc.Repo.Migrations.CreatePullRequestComments do
  use Ecto.Migration

  def change do
    create table("pull_requests") do
      add :external_id, :integer, null: false
      add :title, :string, null: false
      add :description, :string, null: true
      add :status, :string, null: false
      add :created_on, :naive_datetime, null: false
      add :closed_on, :naive_datetime, null: false
      add :source_branch, :string, null: false
      add :target_branch, :string, null: false
      add :is_draft, :boolean, null: false
      add :delete_source_branch, :boolean, null: true
      add :squash_merge, :boolean, null: true
      add :merge_strategy, :string, null: true
      add :ready_for_use, :boolean, null: false
      add :comments_imported_on, :naive_datetime, null: true
      add :repository_id, references("repositories", on_delete: :delete_all), null: false
      add :created_by_id, references("contributors", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("pull_requests", [:repository_id])
    create index("pull_requests", [:created_by_id])
  end
end
