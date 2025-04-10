defmodule Moc.Schema.Counter do
  alias Moc.Schema.Medal
  use Ecto.Schema

  schema "counters" do
    field(:key, :string)
    field(:xp, :float)
    field(:display_order, :integer)
    field(:main_counter, :boolean)
    field(:main_description, :string)
    field(:personal_counter, :boolean)
    field(:personal_description, :string)
    field(:category, :string)
    field(:affinity, :string, default: "neutral")
    field(:charisma, :float, default: 0.0)
    field(:constitution, :float, default: 0.0)
    field(:dexterity, :float, default: 0.0)
    field(:wisdom, :float, default: 0.0)
    has_many(:medals, Medal)
    timestamps()
  end

  def changeset(counter, params \\ %{}) do
    counter
    |> Ecto.Changeset.cast(params, [
      :key,
      :xp,
      :display_order,
      :main_counter,
      :main_description,
      :personal_counter,
      :personal_description,
      :category,
      :affinity,
      :charisma,
      :constitution,
      :dexterity,
      :wisdom
    ])
    |> Ecto.Changeset.validate_required([
      :key,
      :xp,
      :display_order,
      :main_counter,
      :personal_counter,
      :category
    ])
  end
end
