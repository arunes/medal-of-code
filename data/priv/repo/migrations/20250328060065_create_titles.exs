defmodule Moc.Data.Repo.Migrations.CreateTitles do
  use Ecto.Migration

  def change do
    create table("titles") do
      add :title, :string, null: false
      add :xp, :float, null: false

      timestamps()
    end
  end
end
