defmodule Moc.Sync.Runtime.ContributorCache do
  @type t :: pid()

  @me __MODULE__
  use Agent
  alias Moc.Connector.Type
  alias Moc.Sync.Impl.Contributors

  def start_link(_) do
    Agent.start_link(&Contributors.get_contributors/0, name: @me)
  end

  @spec get_id(Type.contributor()) :: integer()
  def get_id(contributor) do
    Agent.get_and_update(@me, fn state ->
      case state[contributor.id] do
        nil ->
          new_id = Contributors.create_contributor(contributor)
          {new_id, Map.put(state, contributor.id, new_id)}

        id ->
          {id, state}
      end
    end)
  end
end
