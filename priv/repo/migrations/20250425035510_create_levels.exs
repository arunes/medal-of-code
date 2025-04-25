defmodule Moc.Repo.Migrations.CreateLevels do
  use Ecto.Migration

  def change do
    create table(:levels) do
      add :level, :float, null: false
      add :xp, :float, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
