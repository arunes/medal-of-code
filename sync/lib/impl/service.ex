defmodule Moc.Sync.Impl.Service do
  alias Moc.Sync.Impl.PullRequests
  alias Moc.Sync.Impl.Comments

  @doc """
  Starts the sync process
  """
  def start_sync do
    IO.puts("Running sync")

    IO.puts("Syncing pull requests")
    PullRequests.sync()

    IO.puts("Syncing comments")
    Comments.sync()

    IO.puts("Sync finished")
  end
end
