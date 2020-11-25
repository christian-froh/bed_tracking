defmodule BedTrackingGraphql.Resolver.Report do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Ward
  alias BedTracking.Repo.Discharge

  def get_report(_params, info) do
    with {:ok, _current_hospital_manager} <- Context.Authentication.current_hospital_manager(info) do
      {:ok, %{report: "report"}}
    end
  end

  def dataloader_total_beds_of_non_surge_wards(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        is_surge_ward
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

      wards = Enum.filter(wards, fn ward -> ward.is_surge_ward == is_surge_ward end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed -> Enum.member?(ward_ids, bed.ward_id) == true end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_critcare_nurses_of_wards(_report, _params, %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)

      total_number_of_critcare_nurses = Enum.map(wards, fn ward -> ward.number_of_critcare_nurses || 0 end) |> Enum.sum()

      {:ok, total_number_of_critcare_nurses}
    end)
  end

  def dataloader_total_other_rns_of_wards(_report, _params, %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)

      total_number_of_other_rns = Enum.map(wards, fn ward -> ward.number_of_other_rns || 0 end) |> Enum.sum()

      {:ok, total_number_of_other_rns}
    end)
  end

  def dataloader_total_nurse_support_staff_of_wards(_report, _params, %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)

      total_number_of_nurse_support_staff = Enum.map(wards, fn ward -> ward.number_of_nurse_support_staff || 0 end) |> Enum.sum()

      {:ok, total_number_of_nurse_support_staff}
    end)
  end

  def dataloader_all_wards_can_provide_ics_ratios(_report, _params, %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)

      can_provide_ics_ratios = Enum.all?(wards, fn ward -> ward.can_provide_ics_ratios == true end)

      {:ok, can_provide_ics_ratios}
    end)
  end

  def dataloader_total_non_available_beds(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

      total_beds =
        Enum.filter(beds, fn bed -> bed.available == false end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_covid_status(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        covid_status
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

      total_beds =
        Enum.filter(beds, fn bed -> bed.available == false and bed.covid_status == covid_status end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        {covid_status1, covid_status2, ventilation_type}
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

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
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        {covid_status1, covid_status2, ventilation_type1, ventilation_type2}
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

      total_beds =
        Enum.filter(beds, fn bed ->
          bed.available == false and (bed.covid_status == covid_status1 or bed.covid_status == covid_status2) and
            (bed.ventilation_type == ventilation_type1 or bed.ventilation_type == ventilation_type2)
        end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_covid_status_and_rrt_type(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        {covid_status1, covid_status2, rrt_type}
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

      total_beds =
        Enum.filter(beds, fn bed ->
          bed.available == false and (bed.covid_status == covid_status1 or bed.covid_status == covid_status2) and bed.rrt_type == rrt_type
        end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_date_admitted_yesterday(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> Dataloader.load(Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
      discharges = Dataloader.get(loader, Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)

      total_beds =
        Enum.filter(beds, fn bed ->
          yesterday = DateTime.add(DateTime.utc_now(), -86400, :second)

          bed.available == false and DateTime.compare(bed.date_of_admission, yesterday) == :gt
        end)
        |> length()

      total_discharges =
        Enum.filter(discharges, fn discharge ->
          yesterday = DateTime.add(DateTime.utc_now(), -86400, :second)

          DateTime.compare(discharge.date_of_admission, yesterday) == :gt
        end)
        |> length()

      total = total_beds + total_discharges
      {:ok, total}
    end)
  end

  def dataloader_total_discharges_where_reason_not_death_and_inserted_at_yesterday(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      discharges = Dataloader.get(loader, Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)

      total_discharges =
        Enum.filter(discharges, fn discharge ->
          yesterday = DateTime.add(DateTime.utc_now(), -86400, :second)

          discharge.reason != "death" and DateTime.compare(discharge.inserted_at, yesterday) == :gt
        end)
        |> length()

      {:ok, total_discharges}
    end)
  end

  def dataloader_total_discharges_where_reason_death_and_inserted_at_yesterday(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      discharges = Dataloader.get(loader, Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)

      total_discharges =
        Enum.filter(discharges, fn discharge ->
          yesterday = DateTime.add(DateTime.utc_now(), -86400, :second)

          discharge.reason == "death" and DateTime.compare(discharge.inserted_at, yesterday) == :gt
        end)
        |> length()

      {:ok, total_discharges}
    end)
  end

  def dataloader_total_non_available_beds_where_ward_type_and_level_of_care(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        {ward_type, level_of_care}
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == ward_type end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed -> bed.available == false and Enum.member?(ward_ids, bed.ward_id) == true and bed.level_of_care == level_of_care end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_ward_type_and_rrt_type_not_none_or_not_risk_of_next_twenty_four_h(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        ward_type
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == ward_type end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed -> bed.available == false and Enum.member?(ward_ids, bed.ward_id) == true and (bed.rrt_type == "haemodialysis" or bed.rrt_type == "haemofiltration" or bed.rrt_type == "pd") end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_ward_type_and_rrt_type_risk_of_next_twenty_four_h(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        ward_type
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == ward_type end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      total_beds =
        Enum.filter(beds, fn bed -> bed.available == false and Enum.member?(ward_ids, bed.ward_id) == true and bed.rrt_type == "risk_of_next_twenty_four_h" end)
        |> length()

      {:ok, total_beds}
    end)
  end

  def dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        {ward_type, source_of_admission}
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
    |> Dataloader.load(Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      wards = Dataloader.get(loader, Repo, {:many, Ward}, hospital_id: current_hospital_manager.hospital_id)
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: current_hospital_manager.hospital_id)
      discharges = Dataloader.get(loader, Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)

      wards = Enum.filter(wards, fn ward -> ward.ward_type == ward_type end)
      ward_ids = Enum.map(wards, fn ward -> ward.id end)

      yesterday = DateTime.add(DateTime.utc_now(), -86400, :second)

      total_beds =
        Enum.filter(beds, fn bed ->
          bed.available == false and Enum.member?(ward_ids, bed.ward_id) == true and bed.source_of_admission == source_of_admission and
            DateTime.compare(bed.date_of_admission, yesterday) == :gt
        end)
        |> length()

      total_discharges =
        Enum.filter(discharges, fn discharge ->
          yesterday = DateTime.add(DateTime.utc_now(), -86400, :second)

          discharge.ward_type == ward_type and discharge.source_of_admission == source_of_admission and DateTime.compare(discharge.date_of_admission, yesterday) == :gt
        end)
        |> length()

      total = total_beds + total_discharges
      {:ok, total}
    end)
  end

  def dataloader_total_discharges_where_reason_not_death_and_ward_type_inserted_at_yesterday(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        ward_type
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      discharges = Dataloader.get(loader, Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)

      total_discharges =
        Enum.filter(discharges, fn discharge ->
          yesterday = DateTime.add(DateTime.utc_now(), -86400, :second)

          discharge.reason != "death" and discharge.ward_type == ward_type and DateTime.compare(discharge.inserted_at, yesterday) == :gt
        end)
        |> length()

      {:ok, total_discharges}
    end)
  end

  def dataloader_total_discharges_where_reason_and_ward_type_inserted_at_yesterday(
        _report,
        _params,
        %{context: %{current_hospital_manager: current_hospital_manager, loader: loader}} = _info,
        {reason, ward_type}
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)
    |> on_load(fn loader ->
      discharges = Dataloader.get(loader, Repo, {:many, Discharge}, hospital_id: current_hospital_manager.hospital_id)

      total_discharges =
        Enum.filter(discharges, fn discharge ->
          yesterday = DateTime.add(DateTime.utc_now(), -86400, :second)

          discharge.reason == reason and discharge.ward_type == ward_type and DateTime.compare(discharge.inserted_at, yesterday) == :gt
        end)
        |> length()

      {:ok, total_discharges}
    end)
  end
end
