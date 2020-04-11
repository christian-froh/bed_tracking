defmodule BedTrackingGraphql.Resolver.Ward do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Hospital

  def create(%{input: %{name: _name} = params}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, ward} <- Context.Ward.create(params, current_hospital.id) do
      {:ok, %{ward: ward}}
    end
  end

  def update(%{input: %{id: id} = params}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, ward} <- Context.Ward.update(id, params) do
      {:ok, %{ward: ward}}
    end
  end

  def remove(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, success} <- Context.Ward.remove(id) do
      {:ok, %{success: success}}
    end
  end

  def update_number_of_beds(
        %{
          input: %{
            ward_id: ward_id,
            number_of_total_beds: number_of_total_beds,
            number_of_available_beds: number_of_available_beds
          }
        },
        info
      ) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, true} <-
           validate_update_number_of_beds(number_of_total_beds, number_of_available_beds),
         {:ok, ward} <-
           Context.Ward.update_number_of_beds(
             ward_id,
             number_of_total_beds,
             number_of_available_beds
           ) do
      {:ok, %{ward: ward}}
    end
  end

  def dataloader_total_beds(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:one, Hospital}, id: ward.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      hospital = Dataloader.get(loader, Repo, {:one, Hospital}, id: ward.hospital_id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_beds =
        if hospital.use_management == true do
          length(beds)
        else
          ward.total_beds
        end

      {:ok, total_beds}
    end)
  end

  def dataloader_available_beds(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:one, Hospital}, id: ward.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      hospital = Dataloader.get(loader, Repo, {:one, Hospital}, id: ward.hospital_id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      available_beds =
        if hospital.use_management == true do
          available_beds = Enum.filter(beds, fn bed -> bed.available == true end)
          length(available_beds)
        else
          ward.available_beds
        end

      {:ok, available_beds}
    end)
  end

  def dataloader_unavailable_beds(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:one, Hospital}, id: ward.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      hospital = Dataloader.get(loader, Repo, {:one, Hospital}, id: ward.hospital_id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      unavailable_beds =
        if hospital.use_management == true do
          unavailable_beds = Enum.filter(beds, fn bed -> bed.available != true end)
          length(unavailable_beds)
        else
          ward.total_beds - ward.available_beds
        end

      {:ok, unavailable_beds}
    end)
  end

  def dataloader_total_covid_status_suspected(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_covid_suspected =
        Enum.filter(beds, fn bed -> bed.covid_status == "suspected" end) |> length()

      {:ok, total_covid_suspected}
    end)
  end

  def dataloader_total_covid_status_negative(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_covid_negative =
        Enum.filter(beds, fn bed -> bed.covid_status == "negative" end) |> length()

      {:ok, total_covid_negative}
    end)
  end

  def dataloader_total_covid_status_positive(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_covid_positive =
        Enum.filter(beds, fn bed -> bed.covid_status == "positive" end) |> length()

      {:ok, total_covid_positive}
    end)
  end

  def dataloader_total_level_of_care_level_1(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_level_1 = Enum.filter(beds, fn bed -> bed.level_of_care == "level_1" end) |> length()

      {:ok, total_level_1}
    end)
  end

  def dataloader_total_level_of_care_level_2(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_level_2 = Enum.filter(beds, fn bed -> bed.level_of_care == "level_2" end) |> length()

      {:ok, total_level_2}
    end)
  end

  def dataloader_total_level_of_care_level_3(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_level_3 = Enum.filter(beds, fn bed -> bed.level_of_care == "level_3" end) |> length()

      {:ok, total_level_3}
    end)
  end

  def dataloader_total_ventilation_type_sv(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_sv = Enum.filter(beds, fn bed -> bed.ventilation_type == "sv" end) |> length()

      {:ok, total_sv}
    end)
  end

  def dataloader_total_ventilation_type_niv(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_niv = Enum.filter(beds, fn bed -> bed.ventilation_type == "niv" end) |> length()

      {:ok, total_niv}
    end)
  end

  def dataloader_total_ventilation_type_intubated(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_intubated =
        Enum.filter(beds, fn bed -> bed.ventilation_type == "intubated" end) |> length()

      {:ok, total_intubated}
    end)
  end

  def dataloader_total_ventilator_in_use(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_ventilator_in_use =
        Enum.filter(beds, fn bed -> bed.ventilation_type != nil end) |> length()

      {:ok, total_ventilator_in_use}
    end)
  end

  defp validate_update_number_of_beds(number_of_total_beds, number_of_available_beds) do
    if number_of_total_beds >= number_of_available_beds do
      {:ok, true}
    else
      {:error,
       %Error.ValidationError{
         reason: "Total number of beds has to be greater than available beds",
         details: "Total number of beds has to be greater than available beds",
         field: "number_of_available_beds"
       }}
    end
  end
end
