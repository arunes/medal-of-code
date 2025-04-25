defmodule Moc.Scoring.TitlePrefix do
  use Ecto.Schema

  schema "title_prefixes" do
    field :prefix, :string
    field :light_percent, :float

    timestamps(type: :utc_datetime)
  end
end
