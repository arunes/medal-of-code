defmodule Moc.Runtime.Setup do
  require Logger
  use Agent
  import Ecto.Query
  alias Moc.Repo
  alias Moc.Schema

  @me __MODULE__

  defstruct [
    :settings,
    :has_org,
    :has_admin
  ]

  def start_link(_args) do
    Logger.info("Starting settings process. '#{@me}'")
    Agent.start_link(&get_initial_state/0, name: @me)
  end

  def get_status() do
    case @me |> Agent.get(fn state -> state end) do
      %{has_admin: false} -> :no_admin
      %{has_org: false} -> :no_org
      _ -> :ok
    end
  end

  def reload() do
    @me |> Agent.update(fn _ -> get_initial_state() end)
  end

  def get_settings() do
    @me |> Agent.get(fn state -> state.settings end)
  end

  def update_settings(settings) do
    settings
    |> Enum.map(fn {key, value} ->
      %Schema.Settings{key: key}
      |> Schema.Settings.changeset(%{value: value})
      |> Repo.update()
    end)

    new_settings =
      get_settings()
      |> Enum.map(fn current ->
        %{current | value: Map.get(settings, current.key, current.value)}
      end)

    @me |> Agent.update(fn state -> %{state | settings: new_settings} end)
  end

  # Impl
  defp get_initial_state() do
    settings = query_get_settings() |> Repo.all()
    has_org = query_first_org_id() |> Repo.one()
    has_admin = query_admin() |> Repo.one()

    %__MODULE__{settings: settings, has_org: has_org != nil, has_admin: has_admin != nil}
  end

  # Queries
  defp query_get_settings() do
    from(st in Schema.Settings,
      select: %{key: st.key, category: st.category, description: st.description, value: st.value}
    )
  end

  defp query_first_org_id() do
    from(org in Schema.Organization, select: org.id, limit: 1)
  end

  defp query_admin() do
    from(usr in Schema.User, where: usr.is_admin, select: usr.id, limit: 1)
  end
end
