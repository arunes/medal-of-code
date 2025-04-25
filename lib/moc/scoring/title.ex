defmodule Moc.Scoring.Title do
  use Ecto.Schema

  schema "titles" do
    field :title, :string
    field :xp, :float

    timestamps(type: :utc_datetime)
  end
end
