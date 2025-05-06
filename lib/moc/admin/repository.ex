defmodule Moc.Admin.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field :external_id, :string
    field :name, :string
    field :url, :string
    field :is_sync_enabled, :boolean
    field :cutoff_date, :utc_datetime

    belongs_to(:project, Moc.Admin.Project)

    timestamps(type: :utc_datetime)
  end

  def toggle_sync_changeset(repository, attrs \\ %{}) do
    repository
    |> cast(attrs, [:is_sync_enabled])
    |> validate_required([:is_sync_enabled])
  end

  def create_changeset(repository, attrs) do
    repository
    |> cast(attrs, [
      :external_id,
      :name,
      :url,
      :is_sync_enabled,
      :cutoff_date,
      :project_id
    ])
    |> validate_required([
      :external_id,
      :name,
      :url,
      :is_sync_enabled,
      :cutoff_date,
      :project_id
    ])
    |> assoc_constraint(:project)
  end
end
