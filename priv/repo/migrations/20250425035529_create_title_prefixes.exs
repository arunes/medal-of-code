defmodule Moc.Repo.Migrations.CreateTitlePrefixes do
  use Ecto.Migration

  def change do
    create table(:title_prefixes) do
      add :prefix, :string, null: false
      add :light_percent, :float, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
