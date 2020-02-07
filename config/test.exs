use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :schtroumpsify, SchtroumpsifyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :schtroumpsify, :frmg,
       url: "frmg_parser_url"

config :extwitter, :oauth, [
  consumer_key: "twitter_consummer_key",
  consumer_secret: "twitter_consummer_secret",
  access_token: "twitter_access_token",
  access_token_secret: "twitter_access_token_secret"
]