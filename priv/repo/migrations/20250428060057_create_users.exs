defmodule Moc.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table("users") do
      add :email, :string, null: false
      add :is_active, :boolean, null: false, default: true
      add :is_admin, :boolean, null: false, default: false
      add :hashed_password, :string, null: true
      add :last_logged_in, :naive_datetime, null: true

      timestamps()
    end

    create index("users", [:email])
  end
end
