defmodule MocData.Schema.ContributorMedal do
  use Ecto.Schema

  schema "contributor_medals" do
    field(:awarded_on, :naive_datetime)
    belongs_to(:contributor, MocData.Schema.Contributor)
    belongs_to(:medal, MocData.Schema.Medal)
    timestamps()
  end

  def changeset(contributor_medal, params \\ %{}) do
    contributor_medal
    |> Ecto.Changeset.cast(params, [:awarded_on, :contributor_id, :medal_id])
    |> Ecto.Changeset.validate_required([:awarded_on, :contributor_id, :medal_id])
    |> Ecto.Changeset.assoc_constraint(:contributor)
    |> Ecto.Changeset.assoc_constraint(:medal)
  end
end
