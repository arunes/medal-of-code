defmodule Moc.Schema.Repository do
  alias Moc.Schema.PullRequest
  use Ecto.Schema

  schema "repositories" do
    field(:external_id, :string)
    field(:name, :string)
    field(:url, :string)
    field(:sync_enabled, :boolean)
    field(:cutoff_date, :naive_datetime)
    belongs_to(:project, Moc.Schema.Project)
    has_many(:pull_requests, PullRequest)

    timestamps()
  end

  def changeset(repository, params \\ %{}) do
    repository
    |> Ecto.Changeset.cast(params, [
      :external_id,
      :name,
      :url,
      :sync_enabled,
      :cutoff_date,
      :project_id
    ])
    |> Ecto.Changeset.validate_required([
      :external_id,
      :name,
      :url,
      :sync_enabled,
      :cutoff_date,
      :project_id
    ])
    |> Ecto.Changeset.assoc_constraint(:project)
  end
end
