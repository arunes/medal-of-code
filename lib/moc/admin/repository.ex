defmodule Moc.Admin.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field :external_id, :string
    field :name, :string
    field :url, :string
    field :sync_enabled, :boolean
    field :cutoff_date, :utc_datetime

    belongs_to(:project, Moc.Admin.Project)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [
      :external_id,
      :name,
      :url,
      :sync_enabled,
      :cutoff_date,
      :project_id
    ])
    |> validate_required([
      :external_id,
      :name,
      :url,
      :sync_enabled,
      :cutoff_date,
      :project_id
    ])
    |> assoc_constraint(:project)
  end
end
