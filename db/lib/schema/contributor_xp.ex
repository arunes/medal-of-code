defmodule Moc.Db.Schema.ContributorXP do
  use Ecto.Schema

  schema "contributor_xp" do
    field(:xp, :float)
    field(:charisma, :integer, default: 0)
    field(:constitution, :integer, default: 0)
    field(:dark_xp, :float)
    field(:dexterity, :integer, default: 0)
    field(:light_xp, :float)
    field(:wisdom, :integer, default: 0)
    belongs_to(:pull_request, Moc.Db.Schema.PullRequest)
    belongs_to(:contributor, Moc.Db.Schema.Contributor)
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
