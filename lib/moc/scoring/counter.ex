defmodule Moc.Scoring.Counter do
  use Ecto.Schema

  schema "counters" do
    field :key, :string
    field :xp, :float
    field :display_order, :integer
    field :is_main_counter, :boolean
    field :main_description, :string
    field :is_personal_counter, :boolean
    field :personal_description, :string
    field :category, :string
    field :affinity, Ecto.Enum, values: [:light, :neutral, :dark]
    field :charisma, :float, default: 0.0
    field :constitution, :float, default: 0.0
    field :dexterity, :float, default: 0.0
    field :wisdom, :float, default: 0.0

    has_many(:medals, Moc.Scoring.Medal)

    timestamps(type: :utc_datetime)
  end
end
