defmodule Moc.Sync do
  alias Moc.Sync.Impl.Service

  defdelegate start_sync, to: Service
end
