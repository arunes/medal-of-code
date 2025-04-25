defmodule Moc.Repo.Migrations.CreateSyncHistories do
  use Ecto.Migration

  def change do
    create table(:sync_histories) do
      add :prs_imported, :integer, null: false, default: 0
      add :reviews_imported, :integer, null: false, default: 0
      add :comments_imported, :integer, null: false, default: 0
      add :error_message, :string, null: true
      add :status, :string, null: false, default: "importing"

      timestamps(type: :utc_datetime)
    end
  end
end
