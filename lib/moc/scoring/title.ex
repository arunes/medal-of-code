defmodule Moc.Scoring.Title do
  use Ecto.Schema
  import Ecto.Changeset

  schema "titles" do
    field :title, :string
    field :xp, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(title, attrs) do
    title
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end
