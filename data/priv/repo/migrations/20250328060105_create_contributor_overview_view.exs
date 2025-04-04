defmodule Moc.Data.Repo.Migrations.CreateContributorOverviewView do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW contributor_overview AS
      SELECT 
        id,
        name,
        COALESCE(LEVEL, 1) AS LEVEL,
        xp,
        dexterity,
        wisdom,
        charisma,
        constitution,
        (xp - currentlevelxp) AS xpProgress,
        CASE nextlevelxp WHEN 0 THEN NULL ELSE (nextlevelxp - currentlevelxp) END AS xpNeeded,
        lightPercent,
        prefix,
        COALESCE(title, 'Ghost') AS title,
        COALESCE(numberofmedals, 0) AS numberOfMedals,
        (SELECT COUNT(*) + 1 FROM contributor_overview so WHERE so.xp > t.xp OR (so.xp = t.xp AND so.name < t.name)) AS rank
      FROM (
      SELECT 
        c.id,
        c.name,
        t.xp,
        t.lightPercent,
        t.dexterity,
        t.wisdom,
        t.charisma,
        t.constitution,
        (SELECT l.level FROM levels l WHERE l.xp <= t.xp ORDER BY l.level DESC LIMIT 1) AS LEVEL,
        (SELECT l.xp FROM levels l WHERE l.xp <= t.xp ORDER BY l.level DESC LIMIT 1) AS currentlevelxp,
        (SELECT l.xp FROM levels l WHERE l.xp > t.xp ORDER BY l.level LIMIT 1) AS nextlevelxp,
        (SELECT tp.prefix FROM title_prefixes tp WHERE tp.light_percent <= COALESCE(t.lightPercent, 50) ORDER BY tp.light_percent DESC LIMIT 1) AS prefix,
        (SELECT t2.title FROM titles t2 WHERE t2.xp < t.xp ORDER BY t2.xp DESC LIMIT 1) AS title,
        (SELECT COUNT(cm.id) FROM contributor_medals cm WHERE cm.contributor_id = c.id) AS numberofmedals
      FROM 
        contributors c
        LEFT JOIN (
          SELECT 
            contributor_id,
            SUM(xp) AS xp,
            COALESCE(((SUM(light_xp) / SUM(xp)) * 100), 0) AS lightPercent,
            SUM(dexterity) AS dexterity,
            SUM(wisdom) AS wisdom,
            SUM(charisma) AS charisma,
            SUM(constitution) AS constitution
          FROM 
            contributor_xp
          GROUP BY 
            contributor_id
        ) t ON t.contributor_id = c.id
      WHERE 
        c.active = TRUE
      ) t
    """
  end

  def down do
    execute "DROP VIEW contributor_overview"
  end
end
