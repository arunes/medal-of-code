defmodule Moc.Sync.Application do
  alias Moc.Sync.Runtime.Server
  use Application

  @impl true
  def start(_type, _args) do
    children = [Server]

    opts = [strategy: :one_for_one, name: Moc.Sync.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
