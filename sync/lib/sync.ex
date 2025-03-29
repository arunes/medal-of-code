defmodule Sync do
  alias Sync.Impl.Service

  defdelegate start_sync, to: Service
end
