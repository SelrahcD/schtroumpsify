use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :schtroumpsify, SchtroumpsifyWeb.Endpoint,
  url: [host: "schtroumpsify.chorip.am", port: 443],
  force_ssl: [hsts: true],
  https: [
    port: 443,
    keyfile:"/etc/letsencrypt/live/schtroumpsify.chorip.am/privkey.pem",
    cacertfile:"/etc/letsencrypt/live/schtroumpsify.chorip.am/chain.pem",
    certfile:"/etc/letsencrypt/live/schtroumpsify.chorip.am/cert.pem"
  ],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: false

            # Do not print debug messages in production
config :logger, level: :info

frmg_parser_url = System.get_env("FRMG_PARSER_URL") ||
  raise """
  environment variable FRMG_PARSER_URL is missing.
  """

config :schtroumpsify, :frmg,
       url: frmg_parser_url

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

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :schtroumpsify, SchtroumpsifyWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :schtroumpsify, SchtroumpsifyWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
import_config "prod.secret.exs"
