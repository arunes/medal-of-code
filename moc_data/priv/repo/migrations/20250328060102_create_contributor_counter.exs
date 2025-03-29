defmodule MocData.Repo.Migrations.CreateContributorCounter do
  use Ecto.Migration

  def change do
    create table("contributor_counter") do
      add :count, :integer, null: false
      add :counter_id, references("counters", on_delete: :delete_all), null: false
      add :contributor_id, references("contributors", on_delete: :delete_all), null: false
      add :repository_id, references("repositories", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("contributor_counter", [:contributor_id])
    create index("contributor_counter", [:repository_id])
    create index("contributor_counter", [:counter_id])
  end
end
