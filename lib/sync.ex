defmodule Moc.Sync do
  require Logger
  alias Moc.Scoring
  alias Moc.Sync.PullRequests
  alias Moc.Sync.Comments

  @doc """
  Starts the sync process
  """
  def start_sync do
    Logger.info("Running sync")

    Logger.info("Syncing pull requests")
    PullRequests.sync()

    Logger.info("Syncing comments")
    Comments.sync()

    Logger.info("Calculating points")
    Scoring.calculate()

    Logger.info("Sync finished")
  end
end
