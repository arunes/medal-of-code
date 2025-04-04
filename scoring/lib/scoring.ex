defmodule Moc.Scoring do
  alias Moc.Scoring.Impl.ScoreService

  defdelegate calculate, to: ScoreService
end
