defmodule MocData.Repo.Migrations.CreateUpdates do
  use Ecto.Migration

  def change do
    create table("updates") do
      add :type, :string
      add :xp, :float, null: true
      add :level, :integer, null: true
      add :title, :string, null: true
      add :prefix, :string, null: true
      add :charisma, :integer, null: true
      add :constitution, :integer, null: true
      add :dexterity, :integer, null: true
      add :wisdom, :integer, null: true
      add :medal_id, references("medals", on_delete: :nothing), null: true
      add :contributor_id, references("contributors", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("updates", [:medal_id])
    create index("updates", [:contributor_id])
  end
end
