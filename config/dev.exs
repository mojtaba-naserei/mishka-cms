import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :mishka_html, MishkaHtmlWeb.Endpoint,
  url: [
    scheme: System.get_env("PROTOCOL"),
    host: System.get_env("CMS_DOMAIN_NAME"),
    port: System.get_env("CMS_PORT")
  ],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    # node: [
    #   "node_modules/webpack/bin/webpack.js",
    #   "--mode",
    #   "development",
    #   "--watch",
    #   "--watch-options-stdin",
    #   cd: Path.expand("../apps/mishka_html/assets", __DIR__)
    # ]
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

config :mishka_api, MishkaApiWeb.Endpoint,
  url: [
    scheme: System.get_env("PROTOCOL"),
    host: System.get_env("API_DOMAIN_NAME"),
    port: System.get_env("API_PORT")
  ],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4001"),
    transport_options: [socket_opts: [:inet6]]
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

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
config :mishka_html, MishkaHtmlWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/mishka_html_web/(live|views)/.*(ex)$",
      ~r"lib/mishka_html_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
