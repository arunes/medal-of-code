defmodule Moc.Schema.Settings do
  use Ecto.Schema

  @primary_key {:key, :string, []}
  schema "settings" do
    field :category, :string
    field :description, :string
    field :value, :string

    timestamps()
  end

  def changeset(settings, params \\ %{}) do
    settings
    |> Ecto.Changeset.cast(params, [:value])
    |> Ecto.Changeset.validate_required([:value])
  end
end
