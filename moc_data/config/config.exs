import Config

config :moc_data, MocData.Repo,
  database: Path.expand("../../moc.db", __DIR__),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :moc_data, ecto_repos: [MocData.Repo]
