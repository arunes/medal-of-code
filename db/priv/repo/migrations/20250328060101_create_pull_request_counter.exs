defmodule Moc.Db.Repo.Migrations.CreatePullRequestCounter do
  use Ecto.Migration

  def change do
    create table("pull_request_counter") do
      add :counter_id, references("counters", on_delete: :delete_all), null: false
      add :pull_request_id, references("pull_requests", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("pull_request_counter", [:pull_request_id])
    create index("pull_request_counter", [:counter_id])
  end
end
