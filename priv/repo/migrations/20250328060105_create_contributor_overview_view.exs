defmodule Moc.Repo.Migrations.CreateContributorOverviewView do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW contributor_overview AS
      SELECT 
        id,
        name,
        COALESCE(level, 1) AS level,
        xp,
        dexterity,
        wisdom,
        charisma,
        constitution,
        (xp - current_level_xp) AS xp_progress,
        CASE next_level_xp WHEN 0 THEN NULL ELSE (next_level_xp - current_level_xp) END AS xp_needed,
        light_percent,
        prefix,
        COALESCE(title, 'Ghost') AS title,
        COALESCE(number_of_medals, 0) AS number_of_medals,
        ROW_NUMBER() OVER (ORDER BY xp DESC) AS rank
      FROM (
        SELECT 
          c.id,
          c.name,
          t.xp,
          t.light_percent,
          t.dexterity,
          t.wisdom,
          t.charisma,
          t.constitution,
          (SELECT l.level FROM levels l WHERE l.xp <= t.xp ORDER BY l.level DESC LIMIT 1) AS level,
          (SELECT l.xp FROM levels l WHERE l.xp <= t.xp ORDER BY l.level DESC LIMIT 1) AS current_level_xp,
          (SELECT l.xp FROM levels l WHERE l.xp > t.xp ORDER BY l.level LIMIT 1) AS next_level_xp,
          (SELECT tp.prefix FROM title_prefixes tp WHERE tp.light_percent <= COALESCE(t.light_percent, 50) ORDER BY tp.light_percent DESC LIMIT 1) AS prefix,
          (SELECT t2.title FROM titles t2 WHERE t2.xp < t.xp ORDER BY t2.xp DESC LIMIT 1) AS title,
          (SELECT COUNT(cm.id) FROM contributor_medals cm WHERE cm.contributor_id = c.id) AS number_of_medals
        FROM 
          contributors c
          LEFT JOIN (
            SELECT 
              contributor_id,
              SUM(xp) AS xp,
              COALESCE(CAST(SUM(light_xp) AS FLOAT) * 100.0 / NULLIF(SUM(xp), 0), 0) AS light_percent,
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
          c.is_visible = 1
      ) tr
    """
  end

  def down do
    execute "DROP VIEW contributor_overview"
  end
end
