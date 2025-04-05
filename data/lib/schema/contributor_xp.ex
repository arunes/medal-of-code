defmodule Moc.Data.Schema.ContributorXP do
  use Ecto.Schema

  schema "contributor_xp" do
    field(:xp, :float)
    field(:charisma, :float, default: 0.0)
    field(:constitution, :float, default: 0.0)
    field(:dark_xp, :float)
    field(:dexterity, :float, default: 0.0)
    field(:light_xp, :float)
    field(:wisdom, :float, default: 0.0)
    belongs_to(:pull_request, Moc.Data.Schema.PullRequest)
    belongs_to(:contributor, Moc.Data.Schema.Contributor)
    timestamps()
  end

  def changeset(contributor_xp, params \\ %{}) do
    contributor_xp
    |> Ecto.Changeset.cast(params, [
      :xp,
      :charisma,
      :constitution,
      :dark_xp,
      :dexterity,
      :light_xp,
      :wisdom,
      :pull_request_id,
      :contributor_id
    ])
    |> Ecto.Changeset.validate_required([
      :xp,
      :dark_xp,
      :light_xp,
      :pull_request_id,
      :contributor_id
    ])
    |> Ecto.Changeset.assoc_constraint(:pull_request)
    |> Ecto.Changeset.assoc_constraint(:contributor)
  end
end
