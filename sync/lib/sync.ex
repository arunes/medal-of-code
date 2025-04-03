defmodule Moc.Sync do
  require Logger
  alias Moc.Sync.Impl.Scores
  alias Moc.Sync.Impl.PullRequests
  alias Moc.Sync.Impl.Comments

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
    Scores.calculate()

    Logger.info("Sync finished")
  end
end
