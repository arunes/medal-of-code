defmodule Moc.ContributorCache do
  @moduledoc """
  A cache for storing contributors, using an Agent to manage the state. Provides function for retrieving contributors by IDs.
  """

  @type t :: pid()

  @me __MODULE__
  use Agent
  require Logger
  import Ecto.Query
  alias Moc.Connector.Type
  alias Moc.Repo
  alias Moc.PullRequests.Contributor

  def start_link(_) do
    Logger.info("Starting contributor cache process. '#{@me}'")
    Agent.start_link(&get_contributors/0, name: @me)
  end

  @doc """
  Gets the contributor db id by it's external id, creates the contributor if doesn't exists
  """
  @spec get_by_id(Type.contributor() | String.t()) :: integer()
  def get_by_id(external_id) when is_binary(external_id),
    do: get_by_id(%{id: external_id, name: "Mysterious Contributor", email: ""})

  def get_by_id(contributor) do
    Agent.get_and_update(@me, fn state ->
      case state[contributor.id] do
        nil ->
          new_id = create_contributor(contributor)
          {new_id, Map.put(state, contributor.id, new_id)}

        id ->
          {id, state}
      end
    end)
  end

  # Impl
  defp get_contributors() do
    query_contributor_ids()
    |> Repo.all()
    |> Enum.reduce(%{}, fn %{external_id: external_id, id: id}, acc ->
      Map.put(acc, external_id, id)
    end)
  end

  defp create_contributor(contributor) do
    {:ok, resp} =
      Contributor.create_changeset(%Contributor{
        external_id: contributor.id,
        name: contributor.name,
        email: contributor.email
      })
      |> Repo.insert()

    resp.id
  end

  # Queries
  defp query_contributor_ids do
    from(c in Contributor,
      select: %{
        id: c.id,
        external_id: c.external_id
      }
    )
  end
end
