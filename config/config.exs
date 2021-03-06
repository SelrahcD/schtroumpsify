# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :schtroumpsify, SchtroumpsifyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hpuYZJ8AOnzYjw2LLKAuPvlB3MI3SQ9U2HQ9uDxJG+ogF7JLU8pryVElUsV+d8Zj",
  render_errors: [view: SchtroumpsifyWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Schtroumpsify.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

