defmodule Moc.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :external_id, :string, null: false
      add :name, :text, null: false
      add :url, :text, null: false
      add :sync_enabled, :boolean, null: false
      add :cutoff_date, :utc_datetime, null: false
      add :project_id, references(:projects, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
