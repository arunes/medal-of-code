defmodule Moc.Scoring do
  alias Moc.Scoring.ScoreService

  defdelegate calculate, to: ScoreService
end
