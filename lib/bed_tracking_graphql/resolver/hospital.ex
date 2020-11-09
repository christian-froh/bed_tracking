defmodule BedTrackingGraphql.Resolver.Hospital do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Ward

  def get_hospitals(_params, info) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospitals} <- Context.Hospital.list() do
      {:ok, %{hospitals: hospitals}}
    end
  end

  def get_hospital(_params, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, hospital} <- Context.Hospital.get(current_hospital.id) do
      {:ok, %{hospital: hospital}}
    end
  end

  def create_hospital(%{input: %{name: _, latitude: _, longitude: _, address: _} = params}, info) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospital} <- Context.Hospital.create(params) do
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

  def dataloader_total_covid_status_suspected(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_covid_suspected =
        Enum.filter(beds, fn bed -> bed.covid_status == "suspected" end)
        |> length()

      {:ok, total_covid_suspected}
    end)
  end

  def dataloader_total_covid_status_negative(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_covid_negative =
        Enum.filter(beds, fn bed -> bed.covid_status == "negative" end)
        |> length()

      {:ok, total_covid_negative}
    end)
  end

  def dataloader_total_covid_status_positive(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_covid_positive =
        Enum.filter(beds, fn bed -> bed.covid_status == "positive" end)
        |> length()

      {:ok, total_covid_positive}
    end)
  end

  def dataloader_total_covid_status_green(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_covid_green =
        Enum.filter(beds, fn bed -> bed.covid_status == "green" end)
        |> length()

      {:ok, total_covid_green}
    end)
  end

  def dataloader_total_level_of_care_level_1(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_level_1 =
        Enum.filter(beds, fn bed -> bed.level_of_care == "level_1" end)
        |> length()

      {:ok, total_level_1}
    end)
  end

  def dataloader_total_level_of_care_level_2(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_level_2 =
        Enum.filter(beds, fn bed -> bed.level_of_care == "level_2" end)
        |> length()

      {:ok, total_level_2}
    end)
  end

  def dataloader_total_level_of_care_level_3(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_level_3 =
        Enum.filter(beds, fn bed -> bed.level_of_care == "level_3" end)
        |> length()

      {:ok, total_level_3}
    end)
  end

  def dataloader_total_rrt_type_none(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_rrt_type_none =
        Enum.filter(beds, fn bed -> bed.rrt_type == "none" end)
        |> length()

      {:ok, total_rrt_type_none}
    end)
  end

  def dataloader_total_rrt_type_risk_of_next_twenty_four_h(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_rrt_type_risk_of_next_twenty_four_h =
        Enum.filter(beds, fn bed -> bed.rrt_type == "risk_of_next_twenty_four_h" end)
        |> length()

      {:ok, total_rrt_type_risk_of_next_twenty_four_h}
    end)
  end

  def dataloader_total_rrt_type_haemodialysis(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_rrt_type_haemodialysis =
        Enum.filter(beds, fn bed -> bed.rrt_type == "haemodialysis" end)
        |> length()

      {:ok, total_rrt_type_haemodialysis}
    end)
  end

  def dataloader_total_rrt_type_haemofiltration(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_rrt_type_haemofiltration =
        Enum.filter(beds, fn bed -> bed.rrt_type == "haemofiltration" end)
        |> length()

      {:ok, total_rrt_type_haemofiltration}
    end)
  end

  def dataloader_total_rrt_type_pd(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_rrt_type_pd =
        Enum.filter(beds, fn bed -> bed.rrt_type == "pd" end)
        |> length()

      {:ok, total_rrt_type_pd}
    end)
  end

  def dataloader_total_ventilator_in_use(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, hospital_id: hospital.id)

      total_ventilator_in_use =
        Enum.filter(beds, fn bed -> bed.ventilation_type != nil end)
        |> length()

      {:ok, total_ventilator_in_use}
    end)
  end
end
