defmodule Moc.Db.Repo.Migrations.CreateContributors do
  use Ecto.Migration

  def change do
    create table("contributors")do
      add :external_id, :string, null: false
      add :name, :text, null: false
      add :email, :string, null: true
      add :active, :boolean, null: false
      add :last_logged_in, :naive_datetime, null: true

      timestamps()
    end
  end
end
