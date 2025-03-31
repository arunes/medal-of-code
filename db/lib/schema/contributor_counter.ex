defmodule Moc.Db.Schema.ContributorCounter do
  use Ecto.Schema

  schema "contributor_counter" do
    field(:count, :integer)
    belongs_to(:counter, Moc.Db.Schema.Counter)
    belongs_to(:contributor, Moc.Db.Schema.Contributor)
    belongs_to(:repository, Moc.Db.Schema.Repository)
    timestamps()
  end

  def changeset(contributor_counter, params \\ %{}) do
    contributor_counter
    |> Ecto.Changeset.cast(params, [:count, :counter_id, :contributor_id, :repository_id])
    |> Ecto.Changeset.validate_required([:count, :counter_id, :contributor_id, :repository_id])
    |> Ecto.Changeset.assoc_constraint(:counter)
    |> Ecto.Changeset.assoc_constraint(:contributor)
    |> Ecto.Changeset.assoc_constraint(:repository)
  end
end
