defmodule MocData.Repo.Migrations.CreateContributors do
  use Ecto.Migration

  def change do
    create table("contributors")do
      add :external_id, :string, null: false
      add :name, :text, null: false
      add :email, :string, null: false
      add :active, :boolean, null: false
      add :last_logged_in, :utc_datetime, null: true

      timestamps()
    end
  end
end
