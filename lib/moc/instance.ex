defmodule Moc.Instance do
  use Agent
  require Logger
  import Ecto.Query
  alias Moc.Admin.Organization
  alias Moc.Instance.Status
  alias Moc.Accounts.User
  alias Moc.Admin.Settings
  alias Moc.Repo

  @me __MODULE__

  def start_link(_args) do
    Logger.info("Starting instance process. '#{@me}'")
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
      %Settings{key: key}
      |> Settings.changeset(%{value: value})
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
    settings =
      from(st in Settings,
        where: st.key != "db.initialized",
        select: %{
          key: st.key,
          category: st.category,
          description: st.description,
          value: st.value
        }
      )
      |> Repo.all()

    has_org = from(org in Organization, select: org.id, limit: 1) |> Repo.one()

    has_admin =
      from(usr in User, where: usr.is_admin, select: usr.id, limit: 1)
      |> Repo.one()

    %Status{settings: settings, has_org: has_org != nil, has_admin: has_admin != nil}
  end
end
