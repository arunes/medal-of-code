defmodule Moc.Sync.Runtime.GenericCache do
  @moduledoc """
  A generic cache implementation, using an Agent to manage the state. 
  """
  require Logger

  @me __MODULE__
  use Agent

  def start_link(_args) do
    Logger.info("Starting generic cache process. '#{@me}'")
    Agent.start_link(fn -> %{} end, name: @me)
  end

  def get(key, if_empty) do
    Agent.get(@me, fn cache -> cache[key] end)
    |> complete(key, if_empty)
  end

  def set(value, key) do
    Agent.get_and_update(@me, fn cache -> {value, Map.put(cache, key, value)} end)
  end

  def has_key?(key) do
    Agent.get(@me, fn cache -> cache |> Map.has_key?(key) end)
  end

  def purge() do
    Agent.update(@me, fn _ -> %{} end)
  end

  # Helpers
  defp complete(nil, key, if_empty) do
    if_empty.() |> set(key)
  end

  defp complete(value, _key, _if_empty), do: value
end
