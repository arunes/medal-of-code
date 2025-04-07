defmodule Moc.Schema.ContributorOverview do
  use Ecto.Schema

  schema "contributor_overview" do
    # field(:id, :integer)
    field(:name, :string)
    field(:level, :integer)
    field(:xp, :float)
    field(:dexterity, :float)
    field(:wisdom, :float)
    field(:charisma, :float)
    field(:constitution, :float)
    field(:xp_progress, :float)
    field(:xp_needed, :float)
    field(:light_percent, :float)
    field(:prefix, :string)
    field(:title, :string)
    field(:number_of_medals, :integer)
    field(:rank, :integer)
  end

  # @primary_key false
end
