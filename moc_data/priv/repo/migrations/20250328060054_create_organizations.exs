defmodule MocData.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table("organizations") do
      add :provider, :string, null: false
      add :token, :string, null: false
      add :external_id, :string, null: false

      timestamps()
    end 
  end
end
