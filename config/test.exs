use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :websflyer, WebsflyerWeb.Endpoint,
  http: [port: 4001],
  debug_errors: true,
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :websflyer, Websflyer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "websflyer_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
