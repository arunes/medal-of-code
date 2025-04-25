defmodule Moc.Scoring.Medal do
  use Ecto.Schema

  schema "medals" do
    field :name, :string
    field :description, :string
    field :count_to_award, :integer
    field :lore, :string
    field :affinity, Ecto.Enum, values: [:light, :neutral, :dark]

    # has_many :contributors, Moc.Contributors.ContributorMedal
    belongs_to(:counter, Moc.Scoring.Counter)

    timestamps(type: :utc_datetime)
  end
end
