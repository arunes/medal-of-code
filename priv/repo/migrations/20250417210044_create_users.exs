defmodule Moc.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :is_active, :boolean, default: false, null: false
      add :is_admin, :boolean, default: false, null: false
      add :hashed_password, :string, null: true
      add :last_logged_in, :utc_datetime, null: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
