defmodule Moc.Data.Runtime.Application do
  alias Moc.Data.Repo
  alias Moc.Data.Runtime.ContributorCache
  use Application

  @impl true
  def start(_type, _args) do
    children = [Repo, ContributorCache]

    opts = [strategy: :one_for_one, name: Moc.Data.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
