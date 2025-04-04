defmodule Moc.Data.Runtime.Application do
  alias Moc.Data.Repo
  alias Moc.Data.Runtime.ContributorCache
  alias Moc.Data.Runtime.MedalCache
  use Application

  @impl true
  def start(_type, _args) do
    children = [Repo, ContributorCache, MedalCache]

    opts = [strategy: :one_for_one, name: Moc.Data.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
