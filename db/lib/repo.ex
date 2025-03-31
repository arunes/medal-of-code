defmodule Moc.Db.Repo do
  use Ecto.Repo,
    otp_app: :db,
    adapter: Ecto.Adapters.SQLite3
end
