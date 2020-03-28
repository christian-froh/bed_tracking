defmodule BedTracking.Repo.HospitalManager do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital

  schema "hospital_managers" do
    field(:name, :string)
    field(:email, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)

    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:name, :email, :password, :hospital_id])
    |> validate_required([:name, :email, :password, :hospital_id])
    |> set_password_hash()
  end

  defp set_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
