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
  pubsub: [name: Schtroumpsify.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

twitter_consummer_key = System.get_env("TWITTER_CONSUMER_KEY") ||
  raise """
  environment variable TWITTER_CONSUMER_KEY is missing.
  """

twitter_consummer_secret = System.get_env("TWITTER_CONSUMER_SECRET") ||
  raise """
  environment variable TWITTER_CONSUMER_SECRET is missing.
  """

twitter_access_token = System.get_env("TWITTER_ACCESS_TOKEN") ||
  raise """
  environment variable TWITTER_ACCESS_TOKEN is missing.
  """

twitter_access_token_secret = System.get_env("TWITTER_ACCESS_TOKEN_SECRET") ||
  raise """
  environment variable TWITTER_ACCESS_TOKEN_SECRET is missing.
  """


config :extwitter, :oauth, [
  consumer_key: twitter_consummer_key,
  consumer_secret: twitter_consummer_secret,
  access_token: twitter_access_token,
  access_token_secret: twitter_access_token_secret
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

