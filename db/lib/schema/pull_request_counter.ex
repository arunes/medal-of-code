defmodule Moc.Db.Schema.PullRequestCounter do
  use Ecto.Schema

  schema "pull_request_counter" do
    belongs_to(:counter, Moc.Db.Schema.Counter)
    belongs_to(:pull_request, Moc.Db.Schema.PullRequest)
    timestamps()
  end

  def changeset(pull_request_counter, params \\ %{}) do
    pull_request_counter
    |> Ecto.Changeset.cast(params, [:counter_id, :pull_request_id])
    |> Ecto.Changeset.validate_required([:counter_id, :pull_request_id])
    |> Ecto.Changeset.assoc_constraint(:counter)
    |> Ecto.Changeset.assoc_constraint(:pull_request)
  end
end
