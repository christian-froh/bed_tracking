import Config

config :bed_tracking, BedTrackingWeb.Endpoint,
  http: [port: String.to_integer(System.fetch_env!("PORT"))],
  url: [host: System.fetch_env!("HOST")],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :bed_tracking, BedTracking.Repo, url: System.fetch_env!("DATABASE_URL")
