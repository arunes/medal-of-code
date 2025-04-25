defmodule Moc.Scoring.Medal do
  use Ecto.Schema
  import Ecto.Changeset

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

  @doc false
  def changeset(medal, attrs) do
    medal
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
