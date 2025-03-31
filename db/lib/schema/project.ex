defmodule Moc.Db.Schema.Project do
  alias Moc.Db.Schema.Repository
  use Ecto.Schema

  schema "projects" do
    field(:external_id, :string)
    field(:name, :string)
    field(:description, :string)
    field(:url, :string)
    belongs_to(:organization, Moc.Db.Schema.Organization)
    has_many(:repositories, Repository)

    timestamps()
  end

  def changeset(project, params \\ %{}) do
    project
    |> Ecto.Changeset.cast(params, [:external_id, :name, :description, :url, :organization_id])
    |> Ecto.Changeset.validate_required([:external_id, :name, :url, :organization_id])
    |> Ecto.Changeset.assoc_constraint(:organization)
  end
end
