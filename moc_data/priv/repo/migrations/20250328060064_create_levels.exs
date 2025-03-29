defmodule MocData.Repo.Migrations.CreateLevels do
  use Ecto.Migration

  def change do
    create table("levels") do
      add :level, :integer, null: false
      add :xp, :integer, null: false

      timestamps()
    end
  end
end
