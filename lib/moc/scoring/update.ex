defmodule Moc.Scoring.Update do
  use Ecto.Schema

  schema "updates" do
    field :type, Ecto.Enum,
      values: [
        :medal_won,
        :xp_increase,
        :level_up,
        :title_change,
        :prefix_change,
        :dexterity_increase,
        :charisma_increase,
        :wisdom_increase,
        :constitution_increase
      ]

    field :xp, :float
    field :level, :integer
    field :title, :string
    field :prefix, :string
    field :charisma, :float
    field :constitution, :float
    field :dexterity, :float
    field :wisdom, :float

    belongs_to(:medal, Moc.Scoring.Medal)
    belongs_to(:contributor, Moc.Contributors.Contributor)

    timestamps(type: :utc_datetime)
  end
end
