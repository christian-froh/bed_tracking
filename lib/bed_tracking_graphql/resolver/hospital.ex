defmodule BedTrackingGraphql.Resolver.Hospital do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Ward

  def get_hospital(_params, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, hospital} <- Context.Hospital.get(current_hospital_manager) do
      {:ok, %{hospital: hospital}}
    end
  end

  def dataloader_total_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      # wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_beds = length(beds)

      {:ok, total_beds}
    end)
  end

  def dataloader_available_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      # wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      available_beds =
        Enum.filter(beds, fn bed -> bed.available == true end)
        |> length()

      {:ok, available_beds}
    end)
  end

  def dataloader_unavailable_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      # wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      unavailable_beds =
        Enum.filter(beds, fn bed -> bed.available != true end)
        |> length()

      {:ok, unavailable_beds}
    end)
  end

  def dataloader_total_amber_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == "amber" end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed -> Enum.member?(ward_ids, bed.ward_id) == true end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_available_amber_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == "amber" end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed ->
          Enum.member?(ward_ids, bed.ward_id) == true && bed.available == true
        end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_green_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == "green" end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed -> Enum.member?(ward_ids, bed.ward_id) == true end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_available_green_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == "green" end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed ->
          Enum.member?(ward_ids, bed.ward_id) == true && bed.available == true
        end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_covid_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == "covid" end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed -> Enum.member?(ward_ids, bed.ward_id) == true end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_available_covid_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == "covid" end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed ->
          Enum.member?(ward_ids, bed.ward_id) == true && bed.available == true
        end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_covid_status(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info,
        covid_status
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_covid_status =
        Enum.filter(beds, fn bed -> bed.covid_status == covid_status end)
        |> length()

      {:ok, total_covid_status}
    end)
  end

  def dataloader_total_level_of_care(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info,
        care_level
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_care_level =
        Enum.filter(beds, fn bed -> bed.level_of_care == care_level end)
        |> length()

      {:ok, total_care_level}
    end)
  end

  def dataloader_total_rrt_type(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info,
        rrt_type
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_rrt_type =
        Enum.filter(beds, fn bed -> bed.rrt_type == rrt_type end)
        |> length()

      {:ok, total_rrt_type}
    end)
  end

  def dataloader_total_ventilation_type(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info,
        ventilation_type
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_ventilation_type =
        Enum.filter(beds, fn bed -> bed.ventilation_type == ventilation_type end)
        |> length()

      {:ok, total_ventilation_type}
    end)
  end

  def dataloader_total_number_of_critcare_nurses(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      total_number_of_critcare_nurses = Enum.map(wards, fn ward -> ward.number_of_critcare_nurses || 0 end) |> Enum.sum()

      {:ok, total_number_of_critcare_nurses}
    end)
  end

  def dataloader_total_number_of_other_rns(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      total_number_of_other_rns = Enum.map(wards, fn ward -> ward.number_of_other_rns || 0 end) |> Enum.sum()

      {:ok, total_number_of_other_rns}
    end)
  end

  def dataloader_total_number_of_nurse_support_staff(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      total_number_of_nurse_support_staff = Enum.map(wards, fn ward -> ward.number_of_nurse_support_staff || 0 end) |> Enum.sum()

      {:ok, total_number_of_nurse_support_staff}
    end)
  end
end
