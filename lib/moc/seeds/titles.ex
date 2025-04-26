defmodule Moc.Seeds.Titles do
  def run do
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Wanderer", xp: 0.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Novice", xp: 2500.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Apprentice", xp: 5625.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Enthusiast", xp: 9532.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Explorer", xp: 14415.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Protégé", xp: 20518.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Connoisseur", xp: 28147.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Specialist", xp: 37684.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Expert", xp: 49605.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Guru", xp: 64506.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Virtuoso", xp: 83133.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Maestro", xp: 106_416.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Master", xp: 135_520.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Legend", xp: 171_899.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Champion", xp: 217_374.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Architect", xp: 274_218.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Wizard", xp: 345_272.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Dynamo", xp: 434_090.0})
    Moc.Repo.insert!(%Moc.Scoring.Title{title: "Grandmaster", xp: 545_112.0})
  end
end
