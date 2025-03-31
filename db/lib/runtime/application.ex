defmodule Moc.Db.Runtime.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [Moc.Db.Repo]

    opts = [strategy: :one_for_one, name: Moc.Db.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
