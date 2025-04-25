defmodule Moc.Contributors.ContributorXP do
  use Ecto.Schema

  schema "contributor_xp" do
    field :xp, :float
    field :charisma, :float, default: 0.0
    field :constitution, :float, default: 0.0
    field :dark_xp, :float
    field :dexterity, :float, default: 0.0
    field :light_xp, :float
    field :wisdom, :float, default: 0.0

    belongs_to(:pull_request, Moc.PullRequests.PullRequest)
    belongs_to(:contributor, Moc.Contributors.Contributor)

    timestamps(type: :utc_datetime)
  end
end
