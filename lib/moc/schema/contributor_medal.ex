defmodule Moc.Schema.ContributorMedal do
  use Ecto.Schema

  schema "contributor_medals" do
    belongs_to(:contributor, Moc.Schema.Contributor)
    belongs_to(:medal, Moc.Schema.Medal)
    timestamps()
  end

  def changeset(contributor_medal, params \\ %{}) do
    contributor_medal
    |> Ecto.Changeset.cast(params, [:contributor_id, :medal_id])
    |> Ecto.Changeset.validate_required([:contributor_id, :medal_id])
    |> Ecto.Changeset.assoc_constraint(:contributor)
    |> Ecto.Changeset.assoc_constraint(:medal)
  end
end
