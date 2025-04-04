defmodule Moc.Data.Repo.Migrations.CreateContributorCounter do
  use Ecto.Migration

  def change do
    create table("contributor_counters") do
      add :count, :integer, null: false
      add :counter_id, references("counters", on_delete: :delete_all), null: false
      add :contributor_id, references("contributors", on_delete: :delete_all), null: false
      add :repository_id, references("repositories", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("contributor_counters", [:contributor_id])
    create index("contributor_counters", [:repository_id])
    create index("contributor_counters", [:counter_id])
  end
end
