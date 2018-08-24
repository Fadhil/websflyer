# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :websflyer,
  ecto_repos: [Websflyer.Repo]

# Configures the endpoint
config :websflyer, WebsflyerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nsCRRd0ShvyQhBEPBsHW8c20zPh0tbncw9PczySuZcZJBYody+wLwlQsr2XUxJCv",
  render_errors: [view: WebsflyerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Websflyer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configure JSON library
config :ecto, :json_library, Jason
config :phoenix, :format_encoders, json: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
