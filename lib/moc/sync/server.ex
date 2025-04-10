defmodule Moc.Sync.Server do
  require Logger
  alias Moc.Sync.Scoring.ScoreService
  alias Moc.Sync.Comments
  alias Moc.Sync.PullRequests

  @me __MODULE__
  @interval :timer.minutes(60)

  use GenServer

  # Client
  def start_link(_args) do
    IO.puts("Starting sync service.")

    GenServer.start_link(@me, :ok, name: @me)
  end

  # Server
  @impl true
  def init(:ok) do
    do_sync()
    schedule_next()
    {:ok, nil}
  end

  @impl true
  def handle_info(:do_sync, _state) do
    do_sync()
    schedule_next()
    {:noreply, nil}
  end

  defp schedule_next() do
    IO.puts("Sync service will run again in #{@interval / 1000 / 60} minutes.")
    Process.send_after(self(), :do_sync, @interval)
  end

  defp do_sync do
    Logger.info("Running sync")

    Logger.info("Syncing pull requests")
    PullRequests.sync()

    Logger.info("Syncing comments")
    Comments.sync()

    Logger.info("Calculating points")
    ScoreService.calculate()

    Logger.info("Sync finished")
  end
end
