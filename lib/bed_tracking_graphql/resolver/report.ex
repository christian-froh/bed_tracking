defmodule BedTrackingGraphql.Resolver.Report do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Ward

  def get_report(_params, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, _hospital} <- Context.Hospital.get(current_hospital.id) do
      {:ok, %{report: "report"}}
    end
  end

  def dataloader_total_beds_of_non_surge_wards(
        _report,
        _params,
        %{context: %{current_hospital: hospital, loader: loader}} = _info,
        is_surge_ward
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      wards = Enum.filter(wards, fn ward -> ward.is_surge_ward == is_surge_ward end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed -> Enum.member?(ward_ids, bed.ward_id) == true end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_critcare_nurses_of_wards(_report, _params, %{context: %{current_hospital: hospital, loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      total_number_of_critcare_nurses = Enum.map(wards, fn ward -> ward.number_of_critcare_nurses || 0 end) |> Enum.sum()

      {:ok, total_number_of_critcare_nurses}
    end)
  end

  def dataloader_total_other_rns_of_wards(_report, _params, %{context: %{current_hospital: hospital, loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      total_number_of_other_rns = Enum.map(wards, fn ward -> ward.number_of_other_rns || 0 end) |> Enum.sum()

      {:ok, total_number_of_other_rns}
    end)
  end

  def dataloader_total_nurse_support_staff_of_wards(_report, _params, %{context: %{current_hospital: hospital, loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      total_number_of_nurse_support_staff = Enum.map(wards, fn ward -> ward.number_of_nurse_support_staff || 0 end) |> Enum.sum()

      {:ok, total_number_of_nurse_support_staff}
    end)
  end

  def dataloader_all_wards_can_provide_ics_ratios(_report, _params, %{context: %{current_hospital: hospital, loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: hospital.id)

      can_provide_ics_ratios = Enum.all?(wards, fn ward -> ward.can_provide_ics_ratios == true end)

      {:ok, can_provide_ics_ratios}
    end)
  end

  def dataloader_total_non_available_beds(
        _report,
        _params,
        %{context: %{current_hospital: hospital, loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_beds =
        Enum.filter(beds, fn bed -> bed.available == false end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_covid_status(
        _report,
        _params,
        %{context: %{current_hospital: hospital, loader: loader}} = _info,
        covid_status
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_beds =
        Enum.filter(beds, fn bed -> bed.available == false and bed.covid_status == covid_status end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(
        _report,
        _params,
        %{context: %{current_hospital: hospital, loader: loader}} = _info,
        {covid_status1, covid_status2, ventilation_type}
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_beds =
        Enum.filter(beds, fn bed ->
          bed.available == false and (bed.covid_status == covid_status1 or bed.covid_status == covid_status2) and bed.ventilation_type == ventilation_type
        end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(
        _report,
        _params,
        %{context: %{current_hospital: hospital, loader: loader}} = _info,
        {covid_status1, covid_status2, ventilation_type1, ventilation_type2}
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_beds =
        Enum.filter(beds, fn bed ->
          bed.available == false and (bed.covid_status == covid_status1 or bed.covid_status == covid_status2) and
            (bed.ventilation_type == ventilation_type1 or bed.ventilation_type == ventilation_type2)
        end)
        |> length()

      {:ok, total_beds}
    end)
  end
end
