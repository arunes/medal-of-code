defmodule Moc.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :external_id, :string, null: false
      add :name, :text, null: false
      add :description, :text, null: true
      add :url, :text, null: false
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
