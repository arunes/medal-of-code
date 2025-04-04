defmodule Moc.Sync.Application do
  alias Moc.Sync.Runtime.GenericCache
  alias Moc.Sync.Runtime.Server
  use Application

  @impl true
  def start(_type, _args) do
    children = get_applications([GenericCache, Server])
    opts = [strategy: :one_for_one, name: Moc.Sync.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def get_applications(apps, result \\ [])
  def get_applications([], result), do: result

  def get_applications([app | rest], result) do
    case Application.get_env(:sync, app) do
      nil ->
        add_application(true, app, get_applications(rest, result))

      cfg ->
        cfg
        |> Keyword.get(:enable, true)
        |> add_application(app, get_applications(rest, result))
    end
  end

  def add_application(true, app, result), do: [app | result]
  def add_application(false, _app, result), do: result
end
