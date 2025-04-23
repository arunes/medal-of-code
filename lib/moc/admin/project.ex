defmodule Moc.Admin.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field(:external_id, :string)
    field(:name, :string)
    field(:description, :string)
    field(:url, :string)

    belongs_to(:organization, Moc.Admin.Organization)
    has_many(:repositories, Moc.Admin.Repository)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:external_id, :name, :description, :url, :organization_id])
    |> validate_required([:external_id, :name, :url, :organization_id])
    |> assoc_constraint(:organization)
  end
end
