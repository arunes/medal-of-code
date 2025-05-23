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

  def update_changeset(settings, attrs) do
    settings
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
