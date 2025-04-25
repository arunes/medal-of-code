defmodule Moc.Repo.Migrations.CreateContributorMedals do
  use Ecto.Migration

  def change do
    create table(:contributor_medals) do
      add :contributor_id, references("contributors", on_delete: :delete_all), null: false
      add :medal_id, references("medals", on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index("contributor_medals", [:contributor_id])
    create index("contributor_medals", [:medal_id])
  end
end
