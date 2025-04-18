defmodule Moc.Admin.Settings do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:key, :string, []}
  schema "settings" do
    field :value, :string
    field :description, :string
    field :category, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [:key, :category, :description, :value])
    |> validate_required([:key, :category, :description, :value])
  end
end
