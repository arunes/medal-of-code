defmodule Moc.Contributors.ContributorMedal do
  use Ecto.Schema

  schema "contributor_medals" do
    belongs_to(:contributor, Moc.Contributors.Contributor)
    belongs_to(:medal, Moc.Scoring.Medal)

    timestamps(type: :utc_datetime)
  end
end
