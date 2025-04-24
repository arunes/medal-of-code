defmodule Moc.Sync do
  alias Moc.PullRequests

  def sync do
    PullRequests.do_import!() |> IO.inspect()
  end
end
