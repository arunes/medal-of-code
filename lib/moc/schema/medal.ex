defmodule Moc.Schema.Medal do
  alias Moc.Schema.ContributorMedal
  use TypedEctoSchema

  typed_schema "medals" do
    field(:name, :string)
    field(:description, :string)
    field(:count_to_award, :integer)
    field(:lore, :string)
    field(:affinity, :string, default: "neutral")
    has_many :contributors, ContributorMedal
    belongs_to(:counter, Moc.Schema.Counter)
    timestamps()
  end

  def changeset(medal, params \\ %{}) do
    medal
    |> Ecto.Changeset.cast(params, [
      :name,
      :description,
      :count_to_award,
      :lore,
      :affinity,
      :counter_id
    ])
    |> Ecto.Changeset.validate_required([
      :name,
      :description,
      :count_to_award,
      :affinity,
      :counter_id
    ])
    |> Ecto.Changeset.assoc_constraint(:counter)
  end
end
