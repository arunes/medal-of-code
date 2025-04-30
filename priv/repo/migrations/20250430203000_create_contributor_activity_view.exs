defmodule Moc.Repo.Migrations.CreateContributorActivityView do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW contributor_activity AS
      SELECT 
        pr.created_by_id AS contributor_id,
        DATE(pr.created_on) AS date
      FROM 
        pull_requests pr
      UNION ALL
      SELECT 
        prc.created_by_id AS contributor_id,
        DATE(prc.published_on) AS date
      FROM 
        pull_request_comments prc
    """
  end

  def down do
    execute "DROP VIEW contributor_activity"
  end
end
