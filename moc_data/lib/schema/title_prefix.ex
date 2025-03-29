defmodule MocData.Schema.TitlePrefix do
  use Ecto.Schema

  schema "title_prefixes" do
    field(:prefix, :string)
    field(:light_percent, :integer)
    timestamps()
  end

  def changeset(title_prefix, params \\ %{}) do
    title_prefix
    |> Ecto.Changeset.cast(params, [:prefix, :light_percent])
    |> Ecto.Changeset.validate_required([:prefix, :light_percent])
  end
end
