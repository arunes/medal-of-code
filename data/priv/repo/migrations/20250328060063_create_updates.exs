defmodule Moc.Data.Repo.Migrations.CreateUpdates do
  use Ecto.Migration

  def change do
    create table("updates") do
      add :type, :string
      add :xp, :float, null: true
      add :level, :float, null: true
      add :title, :string, null: true
      add :prefix, :string, null: true
      add :charisma, :float, null: true
      add :constitution, :float, null: true
      add :dexterity, :float, null: true
      add :wisdom, :float, null: true
      add :medal_id, references("medals", on_delete: :nothing), null: true
      add :contributor_id, references("contributors", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("updates", [:medal_id])
    create index("updates", [:contributor_id])
  end
end
