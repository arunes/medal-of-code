defmodule Moc.Repo.Migrations.CreateContributorCounters do
  use Ecto.Migration

  def change do
    create table(:contributor_counters) do
      add :count, :integer, null: false
      add :counter_id, references("counters", on_delete: :delete_all), null: false
      add :contributor_id, references("contributors", on_delete: :delete_all), null: false
      add :repository_id, references("repositories", on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
