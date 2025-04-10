defmodule Moc.Schema.Update do
  use Ecto.Schema

  schema "updates" do
    field(:type, :string)
    field(:xp, :float)
    field(:level, :integer)
    field(:title, :string)
    field(:prefix, :string)
    field(:charisma, :float)
    field(:constitution, :float)
    field(:dexterity, :float)
    field(:wisdom, :float)
    belongs_to(:medal, Moc.Schema.Medal)
    belongs_to(:contributor, Moc.Schema.Contributor)
    timestamps()
  end

  def changeset(update, params \\ %{}) do
    update
    |> Ecto.Changeset.cast(params, [
      :type,
      :xp,
      :level,
      :title,
      :prefix,
      :charisma,
      :constitution,
      :dexterity,
      :wisdom,
      :medal_id,
      :contributor_id
    ])
    |> Ecto.Changeset.validate_required([:type, :contributor_id])
    |> Ecto.Changeset.assoc_constraint(:medal)
    |> Ecto.Changeset.assoc_constraint(:contributor)
  end
end
