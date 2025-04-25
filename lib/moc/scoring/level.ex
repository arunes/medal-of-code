defmodule Moc.Scoring.Level do
  use Ecto.Schema

  schema "levels" do
    field :level, :integer
    field :xp, :float

    timestamps(type: :utc_datetime)
  end
end
