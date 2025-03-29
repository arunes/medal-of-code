defmodule MocData.Runtime.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [MocData.Repo]

    opts = [strategy: :one_for_one, name: MocData.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
