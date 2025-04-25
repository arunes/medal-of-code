defmodule Moc.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :key, :string, null: false
      add :xp, :float, null: false
      add :display_order, :integer, null: false
      add :main_counter, :boolean, null: false
      add :main_description, :string, null: true
      add :personal_counter, :boolean, null: false
      add :personal_description, :string, null: true
      add :category, :string, null: false
      add :affinity, :string, null: false, default: "neutral"
      add :charisma, :float, null: false, default: 0
      add :constitution, :float, null: false, default: 0
      add :dexterity, :float, null: false, default: 0
      add :wisdom, :float, null: false, default: 0

      timestamps(type: :utc_datetime)
    end
  end
end
