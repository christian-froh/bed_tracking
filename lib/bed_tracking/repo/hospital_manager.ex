defmodule BedTracking.Repo.HospitalManager do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital

  schema "hospital_managers" do
    field(:username, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:is_changed_password, :boolean, default: false)
    field(:is_admin, :boolean, default: false)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:phone_number, :string)
    field(:last_login_at, :utc_datetime)

    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:username, :password, :firstname, :lastname, :phone_number, :hospital_id])
    |> validate_required([:username, :password, :hospital_id])
    |> set_field_to(:is_changed_password, false)
    |> set_password_hash()
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:firstname, :lastname, :phone_number, :last_login_at])
  end

  def change_password_changeset(struct, params) do
    struct
    |> cast(params, [:password])
    |> validate_required([:password])
    |> set_password_hash()
    |> set_field_to(:is_changed_password, true)
  end

  def reset_password_changeset(struct, params) do
    struct
    |> cast(params, [:password])
    |> validate_required([:password])
    |> set_password_hash()
    |> set_field_to(:is_changed_password, false)
  end

  defp set_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  defp set_field_to(changeset, field, value) do
    put_change(changeset, field, value)
  end
end
