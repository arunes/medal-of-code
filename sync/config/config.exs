import Config

config :db, Moc.Db.Repo,
  database: Path.expand("../../moc.db", __DIR__),
  timestamps_opts: [type: :naive_datetime],
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :sync, ecto_repos: [Moc.Db.Repo]

import_config "#{config_env()}.exs"
