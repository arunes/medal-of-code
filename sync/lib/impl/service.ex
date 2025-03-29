defmodule Sync.Impl.Service do
  alias Sync.Impl.PullRequests
  # alias MocData.Schema
  # alias MocData.Repo

  @doc """
  Starts the sync process
  """
  def start_sync do
    IO.puts("Running sync")

    IO.puts("Syncing pull requests")
    PullRequests.sync()

    IO.puts("Sync finished")
  end
end
