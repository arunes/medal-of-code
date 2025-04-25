defmodule Moc.Sync do
  alias Moc.Scoring
  alias Moc.PullRequests

  def sync do
    PullRequests.do_import!()
    Scoring.calculate()
  end
end
