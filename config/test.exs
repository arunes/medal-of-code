import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :moc, Moc.Repo,
  database: Path.expand("../moc#{System.get_env("MIX_TEST_PARTITION")}.db", __DIR__),
  timestamps_opts: [type: :naive_datetime],
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :moc, MocWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Xc8JW6hI9GieGvQsdY+dh4sIUmtomFT3C2Uzud5NXpEMiBFWWUc03qFbkbu0P9Gb",
  server: false

# In test we don't send emails
config :moc, Moc.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
