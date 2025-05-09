defmodule Moc.Seeds.TitlePrefixes do
  def run do
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Corrupted", light_percent: 0.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Tainted", light_percent: 5.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Shadowed", light_percent: 15.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Darkening", light_percent: 25.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Dark", light_percent: 35.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Balanced", light_percent: 45.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Fair", light_percent: 65.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Harmonious", light_percent: 70.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Virtuous", light_percent: 75.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Luminous", light_percent: 80.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Radiant", light_percent: 85.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Shining", light_percent: 90.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Illuminated", light_percent: 95.0})
    Moc.Repo.insert!(%Moc.Scoring.TitlePrefix{prefix: "Neutral", light_percent: 55.0})
  end
end
