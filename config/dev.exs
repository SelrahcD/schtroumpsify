use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :schtroumpsify, SchtroumpsifyWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :schtroumpsify, SchtroumpsifyWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/schtroumpsify_web/{live,views}/.*(ex)$",
      ~r"lib/schtroumpsify_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

frmg_parser_url = System.get_env("FRMG_PARSER_URL") || "FRMG_PARSER_URL"

config :schtroumpsify, :frmg,
       url: frmg_parser_url

twitter_consummer_key = System.get_env("TWITTER_CONSUMER_KEY") || "TWITTER_CONSUMER_KEY"

twitter_consummer_secret = System.get_env("TWITTER_CONSUMER_SECRET") || "TWITTER_CONSUMER_SECRET"

twitter_access_token = System.get_env("TWITTER_ACCESS_TOKEN") || "TWITTER_ACCESS_TOKEN"

twitter_access_token_secret = System.get_env("TWITTER_ACCESS_TOKEN_SECRET") || "TWITTER_ACCESS_TOKEN_SECRET"

config :extwitter, :oauth, [
  consumer_key: twitter_consummer_key,
  consumer_secret: twitter_consummer_secret,
  access_token: twitter_access_token,
  access_token_secret: twitter_access_token_secret
]

