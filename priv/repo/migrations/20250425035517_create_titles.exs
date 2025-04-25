defmodule Moc.Repo.Migrations.CreateTitles do
  use Ecto.Migration

  def change do
    create table(:titles) do
      add :title, :string, null: false
      add :xp, :float, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
