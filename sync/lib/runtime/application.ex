defmodule Sync.Application do
  alias Sync.Runtime.Server
  use Application

  @impl true
  def start(_type, _args) do
    children = [Server]

    opts = [strategy: :one_for_one, name: Sync.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
