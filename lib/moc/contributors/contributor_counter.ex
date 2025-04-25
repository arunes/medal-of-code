defmodule Moc.Contributors.ContributorCounter do
  use Ecto.Schema

  schema "contributor_counters" do
    field :count, :integer

    belongs_to(:counter, Moc.Scoring.Counter)
    belongs_to(:contributor, Moc.Contributors.Contributor)
    belongs_to(:repository, Moc.Admin.Repository)

    timestamps(type: :utc_datetime)
  end
end
