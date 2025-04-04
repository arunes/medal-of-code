defmodule Moc.Data.Repo do
  use Ecto.Repo,
    otp_app: :moc_data,
    adapter: Ecto.Adapters.SQLite3
end
