defmodule BedTracking.Context.Hospital do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Hospital

  def list() do
    hospitals =
      Hospital
      |> Repo.all()

    {:ok, hospitals}
  end

  def get(hospital_id) do
    Hospital
    |> Context.Hospital.Query.where_id(hospital_id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.NotFoundError{fields: %{id: hospital_id}, type: "Hospital"}}

      hospital ->
        {:ok, hospital}
    end
  end

  def create(params) do
    with {:ok, hospital} <- create_hospital(params) do
      {:ok, hospital}
    end
  end

  def use_qr_code_system(use_qr_code, hospital_id) do
    with {:ok, hospital} <- get(hospital_id),
         {:ok, updated_hospital} <- update_qr_code(use_qr_code, hospital) do
      {:ok, updated_hospital}
    end
  end

  defp create_hospital(params) do
    %Hospital{}
    |> Hospital.create_changeset(params)
    |> Repo.insert()
  end

  defp update_qr_code(use_qr_code, hospital) do
    params = %{use_qr_code: use_qr_code}

    Hospital.use_qr_code_changeset(hospital, params)
    |> Repo.update()
  end
end
