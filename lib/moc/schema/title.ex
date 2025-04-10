defmodule Moc.Schema.Title do
  use Ecto.Schema

  schema "titles" do
    field(:title, :string)
    field(:xp, :float)
    timestamps()
  end

  def changeset(title, params \\ %{}) do
    title
    |> Ecto.Changeset.cast(params, [:title, :xp])
    |> Ecto.Changeset.validate_required([:title, :xp])
  end
end
