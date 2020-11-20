defmodule BedTrackingGraphql.Resolver.Ward do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Hospital
  alias BedTracking.Repo.HospitalManager

  def create(%{input: %{name: _name, ward_type: _ward_type} = params}, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, ward} <- Context.Ward.create(params, current_hospital_manager) do
      {:ok, %{ward: ward}}
    end
  end

  def update(%{input: %{id: id} = params}, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, ward} <- Context.Ward.update(id, params, current_hospital_manager) do
      {:ok, %{ward: ward}}
    end
  end

  def remove(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, success} <- Context.Ward.remove(id) do
      {:ok, %{success: success}}
    end
  end

  def dataloader_last_updated_at_of_ward_or_beds(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)
      sorted_beds = Enum.sort_by(beds, & &1.updated_at, {:desc, DateTime})

      case List.first(sorted_beds) do
        nil ->
          {:ok, ward.updated_at}

        first_bed ->
          last_updated_at =
            case DateTime.compare(first_bed.updated_at, ward.updated_at) do
              :lt -> ward.updated_at
              _ -> first_bed.updated_at
            end

          {:ok, last_updated_at}
      end
    end)
  end

  def dataloader_last_updated_by_hospital_manager_of_ward_or_beds(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:one, HospitalManager}, id: ward.updated_by_hospital_manager_id)
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      hospital_manager = Dataloader.get(loader, Repo, {:one, HospitalManager}, id: ward.updated_by_hospital_manager_id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)
      sorted_beds = Enum.sort_by(beds, & &1.updated_at, {:desc, DateTime})

      case List.first(sorted_beds) do
        nil ->
          {:ok, hospital_manager}

        first_bed ->
          loader
          |> Dataloader.load(Repo, {:one, HospitalManager}, id: first_bed.updated_by_hospital_manager_id)
          |> on_load(fn loader ->
            bed_hospital_manager = Dataloader.get(loader, Repo, {:one, HospitalManager}, id: first_bed.updated_by_hospital_manager_id)

            hospital_manager =
              case DateTime.compare(first_bed.updated_at, ward.updated_at) do
                :lt -> hospital_manager
                _ -> bed_hospital_manager
              end

            {:ok, hospital_manager}
          end)
      end
    end)
  end

  def dataloader_total_beds(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:one, Hospital}, id: ward.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      # hospital = Dataloader.get(loader, Repo, {:one, Hospital}, id: ward.hospital_id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_beds = length(beds)

      {:ok, total_beds}
    end)
  end

  def dataloader_available_beds(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:one, Hospital}, id: ward.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      # hospital = Dataloader.get(loader, Repo, {:one, Hospital}, id: ward.hospital_id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      available_beds =
        Enum.filter(beds, fn bed -> bed.available == true end)
        |> length()

      {:ok, available_beds}
    end)
  end

  def dataloader_unavailable_beds(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:one, Hospital}, id: ward.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      # hospital = Dataloader.get(loader, Repo, {:one, Hospital}, id: ward.hospital_id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      unavailable_beds =
        Enum.filter(beds, fn bed -> bed.available != true end)
        |> length()

      {:ok, unavailable_beds}
    end)
  end

  def dataloader_total_covid_status(
        ward,
        _params,
        %{context: %{loader: loader}} = _info,
        covid_status
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_covid_status =
        Enum.filter(beds, fn bed -> bed.covid_status == covid_status end)
        |> length()

      {:ok, total_covid_status}
    end)
  end

  def dataloader_total_level_of_care(
        ward,
        _params,
        %{context: %{loader: loader}} = _info,
        care_level
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_care_level =
        Enum.filter(beds, fn bed -> bed.level_of_care == care_level end)
        |> length()

      {:ok, total_care_level}
    end)
  end

  def dataloader_total_rrt_type(
        ward,
        _params,
        %{context: %{loader: loader}} = _info,
        rrt_type
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_rrt_type =
        Enum.filter(beds, fn bed -> bed.rrt_type == rrt_type end)
        |> length()

      {:ok, total_rrt_type}
    end)
  end

  def dataloader_total_ventilation_type(
        ward,
        _params,
        %{context: %{loader: loader}} = _info,
        ventilation_type
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_ventilation_type =
        Enum.filter(beds, fn bed -> bed.ventilation_type == ventilation_type end)
        |> length()

      {:ok, total_ventilation_type}
    end)
  end
end
