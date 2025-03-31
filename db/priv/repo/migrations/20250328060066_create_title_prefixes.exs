defmodule Moc.Db.Repo.Migrations.CreateTitlePrefixes do
  use Ecto.Migration

  def change do
    create table("title_prefixes") do
      add :prefix, :string, null: false
      add :light_percent, :integer, null: false

      timestamps()
    end
  end
end
