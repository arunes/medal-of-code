defmodule Moc.Data.Schema.Level do
  use Ecto.Schema

  schema "levels" do
    field(:level, :integer)
    field(:xp, :float)
    timestamps()
  end

  def changeset(level, params \\ %{}) do
    level
    |> Ecto.Changeset.cast(params, [:level, :xp])
    |> Ecto.Changeset.validate_required([:level, :xp])
  end
end
