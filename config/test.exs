use Mix.Config

# Configure your database
config :bed_tracking, BedTracking.Repo,
  username: "postgres",
  password: "postgres",
  database: "bed_tracking_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bed_tracking, BedTrackingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
