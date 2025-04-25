defmodule Moc.Repo.Migrations.CreatePullRequestCounters do
  use Ecto.Migration

  def change do
    create table(:pull_request_counters) do
      add :counter_id, references("counters", on_delete: :delete_all), null: false
      add :pull_request_id, references("pull_requests", on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index("pull_request_counters", [:pull_request_id])
    create index("pull_request_counters", [:counter_id])
  end
end
