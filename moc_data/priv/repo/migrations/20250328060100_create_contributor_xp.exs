defmodule MocData.Repo.Migrations.CreateContributorXp do
  use Ecto.Migration

  def change do
    create table("contributor_xp") do
      add :xp, :float, null: false
      add :charisma, :integer, null: false, default: 0
      add :constitution, :integer, null: false, default: 0
      add :dark_xp, :float, null: false
      add :dexterity, :integer, null: false, default: 0
      add :light_xp, :float, null: false
      add :wisdom, :integer, null: false, default: 0
      add :pull_request_id, references("pull_requests", on_delete: :delete_all), null: false
      add :contributor_id, references("contributors", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("contributor_xp", [:contributor_id])
    create index("contributor_xp", [:pull_request_id])
  end
end
