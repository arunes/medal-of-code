defmodule Moc.Sync.Server do
  alias Moc.Sync

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
    Sync.start_sync()
    schedule_next()
    {:ok, nil}
  end

  @impl true
  def handle_info(:do_sync, _state) do
    Sync.start_sync()
    schedule_next()
    {:noreply, nil}
  end

  defp schedule_next() do
    IO.puts("Sync service will run again in #{@interval / 1000 / 60} minutes.")
    Process.send_after(self(), :do_sync, @interval)
  end
end
