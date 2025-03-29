defmodule MocData.Schema.Contributor do
  use Ecto.Schema

  schema "contributors" do
    field(:external_id, :string)
    field(:name, :string)
    field(:email, :string)
    field(:avatar, :string)
    field(:active, :boolean)
    field(:last_logged_in, :utc_datetime)
    timestamps()
  end

  def changeset(contributor, params \\ %{}) do
    contributor
    |> Ecto.Changeset.cast(params, [:external_id, :name, :email, :avatar, :active, :last_logged_in])
    |> Ecto.Changeset.validate_required([:external_id, :name, :email, :active])
    |> Ecto.Changeset.validate_format(:email, ~r/@/)
  end
end
