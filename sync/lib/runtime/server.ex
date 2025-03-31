defmodule Moc.Sync.Runtime.Server do
  alias Moc.Sync.Impl.Service
  @me __MODULE__
  @interval :timer.minutes(1)

  use GenServer

  # Client
  def start_link(_args) do
    IO.puts("Starting sync service.")

    GenServer.start_link(@me, :ok, name: @me)
  end

  # Server
  @impl true
  def init(:ok) do
    Service.start_sync()
    schedule_next()
    {:ok, nil}
  end

  @impl true
  def handle_info(:do_sync, _state) do
    Service.start_sync()
    schedule_next()
    {:noreply, nil}
  end

  defp schedule_next() do
    IO.puts("Sync ervice will run again in #{@interval / 1000 / 1000} minutes.")
    Process.send_after(self(), :do_sync, @interval)
  end
end
