defmodule MocData.Schema.Organization do
  alias MocData.Schema.Project
  use Ecto.Schema

  schema "organizations" do
    field(:provider, :string)
    field(:token, :string)
    field(:external_id, :string)
    has_many(:projects, Project)

    timestamps()
  end

  def changeset(organization, params \\ %{}) do
    organization
    |> Ecto.Changeset.cast(params, [:provider, :token, :external_id])
    |> Ecto.Changeset.validate_required([:provider, :token, :external_id])
  end
end
