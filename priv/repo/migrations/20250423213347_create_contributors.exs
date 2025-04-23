defmodule Moc.Repo.Migrations.CreateContributors do
  use Ecto.Migration

  def change do
    create table(:contributors) do
      add :external_id, :string, null: false
      add :name, :text, null: false
      add :email, :string, null: true
      add :is_visible, :boolean, null: false, default: true

      timestamps(type: :utc_datetime)
    end
  end
end
