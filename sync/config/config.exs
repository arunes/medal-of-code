import Config

config :moc_data, Moc.Data.Repo,
  database: Path.expand("../../moc.db", __DIR__),
  timestamps_opts: [type: :naive_datetime],
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :moc_sync, ecto_repos: [Moc.Data.Repo]

import_config "#{config_env()}.exs"
