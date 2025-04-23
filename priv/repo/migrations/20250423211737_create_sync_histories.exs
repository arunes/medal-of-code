defmodule Moc.Repo.Migrations.CreateSyncHistories do
  use Ecto.Migration

  def change do
    create table(:sync_histories) do
      add :prs_imported, :integer
      add :prs_reviews_imported, :integer
      add :comments_imported, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
