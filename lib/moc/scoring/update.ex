defmodule Moc.Scoring.Update do
  use Ecto.Schema

  schema "updates" do
    field :type, :string
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
