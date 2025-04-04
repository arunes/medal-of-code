defmodule Moc.Data.Schema.Medal do
  use TypedEctoSchema

  typed_schema "medals" do
    field(:name, :string)
    field(:description, :string)
    field(:count_to_award, :integer)
    field(:lore, :string)
    field(:affinity, :string, default: "neutral")
    belongs_to(:counter, Moc.Data.Schema.Counter)
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
