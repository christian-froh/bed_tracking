# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bed_tracking,
  ecto_repos: [BedTracking.Repo],
  generators: [binary_id: true],
  token_secret: "rwXhvaM/jd6J1ZQWONddzBoAK3a/O4neBCqLrq3SyIiJf38wh1t1SBvA90KC3xI2",
  token_salt: "bed-tracking",
  token_max_age: 86_400_000

config :cors_plug,
  origin: ["*"],
  max_age: 1_728_000,
  methods: ["GET", "POST"]

# Configures the endpoint
config :bed_tracking, BedTrackingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "O1/8XYXIFsE3iy5Qq+GTxkqmgceJ/3LvAp0NWcMQEEsEIHlAD9gjHEN7u5a2U4W9",
  render_errors: [view: BedTrackingWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BedTracking.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
