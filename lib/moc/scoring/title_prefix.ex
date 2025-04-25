defmodule Moc.Scoring.TitlePrefix do
  use Ecto.Schema
  import Ecto.Changeset

  schema "title_prefixes" do
    field :prefix, :string
    field :light_percent, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(title_prefix, attrs) do
    title_prefix
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end
