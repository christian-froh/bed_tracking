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

  def use_management_system(%{input: %{use_management: use_management}}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, hospital} <-
           Context.Hospital.use_management_system(use_management, current_hospital.id) do
      {:ok, %{hospital: hospital}}
    end
  end

  def dataloader_total_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward, query_fun: {Ward, nil}}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards =
        Dataloader.get(loader, Repo, {:many, Ward, query_fun: {Ward, nil}},
          hospital_id: hospital.id
        )

      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_beds =
        if hospital.use_management == true do
          length(beds)
        else
          wards_total_beds = Enum.map(wards, fn ward -> ward.total_beds end)
          Enum.sum(wards_total_beds)
        end

      {:ok, total_beds}
    end)
  end

  def dataloader_available_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward, query_fun: {Ward, nil}}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards =
        Dataloader.get(loader, Repo, {:many, Ward, query_fun: {Ward, nil}},
          hospital_id: hospital.id
        )

      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      available_beds =
        if hospital.use_management == true do
          available_beds = Enum.filter(beds, fn bed -> bed.available == true end)
          length(available_beds)
        else
          wards_available_beds = Enum.map(wards, fn ward -> ward.available_beds end)
          Enum.sum(wards_available_beds)
        end

      {:ok, available_beds}
    end)
  end

  def dataloader_unavailable_beds(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Ward, query_fun: {Ward, nil}}, hospital_id: hospital.id)
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      wards =
        Dataloader.get(loader, Repo, {:many, Ward, query_fun: {Ward, nil}},
          hospital_id: hospital.id
        )

      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      unavailable_beds =
        if hospital.use_management == true do
          unavailable_beds = Enum.filter(beds, fn bed -> bed.available != true end)
          length(unavailable_beds)
        else
          wards_unavailable_beds =
            Enum.map(wards, fn ward -> ward.total_beds - ward.available_beds end)

          Enum.sum(wards_unavailable_beds)
        end

      {:ok, unavailable_beds}
    end)
  end

  def dataloader_total_covid_status_suspected(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_covid_suspected =
        Enum.filter(beds, fn bed -> bed.covid_status == "suspected" end) |> length()

      {:ok, total_covid_suspected}
    end)
  end

  def dataloader_total_covid_status_negative(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_covid_negative =
        Enum.filter(beds, fn bed -> bed.covid_status == "negative" end) |> length()

      {:ok, total_covid_negative}
    end)
  end

  def dataloader_total_covid_status_positive(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_covid_positive =
        Enum.filter(beds, fn bed -> bed.covid_status == "positive" end) |> length()

      {:ok, total_covid_positive}
    end)
  end

  def dataloader_total_level_of_care_level_1(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_level_1 = Enum.filter(beds, fn bed -> bed.level_of_care == "level_1" end) |> length()

      {:ok, total_level_1}
    end)
  end

  def dataloader_total_level_of_care_level_2(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_level_2 = Enum.filter(beds, fn bed -> bed.level_of_care == "level_2" end) |> length()

      {:ok, total_level_2}
    end)
  end

  def dataloader_total_level_of_care_level_3(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_level_3 = Enum.filter(beds, fn bed -> bed.level_of_care == "level_3" end) |> length()

      {:ok, total_level_3}
    end)
  end

  def dataloader_total_ventilation_type_sv(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_sv = Enum.filter(beds, fn bed -> bed.ventilation_type == "sv" end) |> length()

      {:ok, total_sv}
    end)
  end

  def dataloader_total_ventilation_type_niv(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_niv = Enum.filter(beds, fn bed -> bed.ventilation_type == "niv" end) |> length()

      {:ok, total_niv}
    end)
  end

  def dataloader_total_ventilation_type_intubated(
        hospital,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_intubated =
        Enum.filter(beds, fn bed -> bed.ventilation_type == "intubated" end) |> length()

      {:ok, total_intubated}
    end)
  end

  def dataloader_total_ventilator_in_use(hospital, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)
    |> on_load(fn loader ->
      beds =
        Dataloader.get(loader, Repo, {:many, Bed, query_fun: {Bed, nil}}, hospital_id: hospital.id)

      total_ventilator_in_use =
        Enum.filter(beds, fn bed -> bed.ventilation_type != nil end) |> length()

      {:ok, total_ventilator_in_use}
    end)
  end
end
