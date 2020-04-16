# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :reflections,
  ecto_repos: [Reflections.Repo]

# Configures the endpoint
config :reflections, ReflectionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EKOBrO8CnKNo8x9YUzMGZELQN7WbMxRiwRDZCEv3KQ6HhYo2UlvKn6ABEkOgtZcy",
  render_errors: [view: ReflectionsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Reflections.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "6TU8DoIm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
