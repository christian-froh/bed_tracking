defmodule BedTracking.Repo.Admin do
  use BedTracking.Repo.Schema

  schema "admins" do
    field(:email, :string)
    field(:name, :string)
    field(:password_hash, :string)

    timestamps()
  end
end
