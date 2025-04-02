defmodule Moc.Sync.Runtime.ScoreCache do
  @moduledoc """
  A cache for storing scores, using an Agent to manage the state. Provides function for retrieving contributors by IDs.
  """

  @me __MODULE__
  use Agent
  alias Moc.Sync.Type

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: @me)
  end

  @spec add(Type.score_result()) :: :ok
  def add(new_score) do
    Agent.update(@me, fn cache ->
      cache
      |> Enum.find(fn s ->
        s.contributor_id == new_score.contributor_id and
          s.repository_id == new_score.repository_id and
          s.counter_id == new_score.counter_id
      end)
      |> handle_add(cache, new_score)
    end)
  end

  defp handle_add(nil, cache, new_score) do
    item = %{
      contributor_id: new_score.contributor_id,
      repository_id: new_score.repository_id,
      counter_id: new_score.counter_id,
      old_count: new_score.old_count,
      contributor_counter_id: new_score.contributor_counter_id,
      data: [
        new_score
        |> Map.delete(:contributor_id)
        |> Map.delete(:repository_id)
        |> Map.delete(:counter_id)
        |> Map.delete(:old_count)
        |> Map.delete(:contributor_counter_id)
      ]
    }

    [item | cache]
  end

  defp handle_add(cache_item, cache, new_score) do
    data =
      new_score
      |> Map.delete(:contributor_id)
      |> Map.delete(:repository_id)
      |> Map.delete(:counter_id)
      |> Map.delete(:old_count)
      |> Map.delete(:contributor_counter_id)

    item = cache_item |> Map.put(:data, [data | cache_item.data])
    [item | cache]
  end

  @spec get_all() :: list(Type.score_result())
  def get_all, do: Agent.get(@me, fn cache -> cache end)

  @spec purge() :: :ok
  def purge, do: Agent.update(@me, fn _ -> [] end)
end
