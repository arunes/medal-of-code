defmodule Moc.Repo.Migrations.CreateMedals do
  use Ecto.Migration

  def change do
    create table(:medals) do
      add :name, :string, null: false
      add :description, :string, null: false
      add :count_to_award, :float, null: false
      add :lore, :string, null: true
      add :affinity, :string, null: false, default: "neutral"
      add :counter_id, references("counters", on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index("medals", [:counter_id])
  end
end
