defmodule Moc.Repo do
  use Ecto.Repo,
    otp_app: :moc,
    adapter: Ecto.Adapters.SQLite3
end
