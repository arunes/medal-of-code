defmodule Moc.Scoring.MedalCache do
  @moduledoc """
  A cache for storing medals, using an Agent to manage the state. Provides function for retrieving contributors by IDs.
  """

  @type t :: pid()

  @me __MODULE__
  use Agent
  import Ecto.Query
  alias Moc.Repo
  alias Moc.Scoring.Medal

  def start_link(_) do
    Agent.start_link(&get_medals/0, name: @me)
  end

  @doc """
  Gets the medal by id 
  """
  def get_by_id(medal_id) do
    Agent.get(@me, fn state -> state[medal_id] end)
  end

  @doc """
  Gets the medal by counter id 
  """
  def get_by_counter_id(counter_id) do
    Agent.get(@me, fn state ->
      state
      |> Enum.filter(fn {_k, v} -> v.counter_id == counter_id end)
      |> Enum.map(fn {_k, v} -> v end)
    end)
  end

  @doc """
  Gets all the medals
  """
  def get_all() do
    Agent.get(@me, fn state -> state |> Enum.map(fn {_k, v} -> v end) end)
  end

  # Impl
  defp get_medals() do
    query_medals()
    |> Repo.all()
    |> Enum.map(fn m -> {m.id, m} end)
    |> Enum.into(%{})
  end

  # Queries
  defp query_medals do
    from(c in Medal)
  end
end
