defmodule BedTracking.Repo do
  use Ecto.Repo,
    otp_app: :bed_tracking,
    adapter: Ecto.Adapters.Postgres
end
