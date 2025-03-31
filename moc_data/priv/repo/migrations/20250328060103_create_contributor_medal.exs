defmodule MocData.Repo.Migrations.CreateContributorMedal do
  use Ecto.Migration

  def change do
    create table("contributor_medals") do
      add :awarded_on, :naive_datetime, null: false
      add :contributor_id, references("contributors", on_delete: :delete_all), null: false
      add :medal_id, references("medals", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("contributor_medals", [:contributor_id])
    create index("contributor_medals", [:medal_id])
  end
end
