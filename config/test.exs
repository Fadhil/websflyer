use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :webs_flyer, WebsFlyerWeb.Endpoint,
  http: [port: 4001],
  debug_errors: true,
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :webs_flyer, WebsFlyer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "webs_flyer_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
