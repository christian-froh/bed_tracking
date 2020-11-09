defmodule BedTrackingGraphql.Resolver.Ward do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
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
        Enum.filter(beds, fn bed -> bed.covid_status == "suspected" end)
        |> length()

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
        Enum.filter(beds, fn bed -> bed.covid_status == "negative" end)
        |> length()

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
        Enum.filter(beds, fn bed -> bed.covid_status == "positive" end)
        |> length()

      {:ok, total_covid_positive}
    end)
  end

  def dataloader_total_covid_status_green(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_covid_green =
        Enum.filter(beds, fn bed -> bed.covid_status == "green" end)
        |> length()

      {:ok, total_covid_green}
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

      total_level_1 =
        Enum.filter(beds, fn bed -> bed.level_of_care == "level_1" end)
        |> length()

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

      total_level_2 =
        Enum.filter(beds, fn bed -> bed.level_of_care == "level_2" end)
        |> length()

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

      total_level_3 =
        Enum.filter(beds, fn bed -> bed.level_of_care == "level_3" end)
        |> length()

      {:ok, total_level_3}
    end)
  end

  def dataloader_total_rrt_type_none(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_rrt_type_none =
        Enum.filter(beds, fn bed -> bed.rrt_type == "none" end)
        |> length()

      {:ok, total_rrt_type_none}
    end)
  end

  def dataloader_total_rrt_type_risk_of_next_twenty_four_h(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_rrt_type_risk_of_next_twenty_four_h =
        Enum.filter(beds, fn bed -> bed.rrt_type == "risk_of_next_twenty_four_h" end)
        |> length()

      {:ok, total_rrt_type_risk_of_next_twenty_four_h}
    end)
  end

  def dataloader_total_rrt_type_haemodialysis(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_rrt_type_haemodialysis =
        Enum.filter(beds, fn bed -> bed.rrt_type == "haemodialysis" end)
        |> length()

      {:ok, total_rrt_type_haemodialysis}
    end)
  end

  def dataloader_total_rrt_type_haemofiltration(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_rrt_type_haemofiltration =
        Enum.filter(beds, fn bed -> bed.rrt_type == "haemofiltration" end)
        |> length()

      {:ok, total_rrt_type_haemofiltration}
    end)
  end

  def dataloader_total_rrt_type_pd(
        ward,
        _params,
        %{context: %{loader: loader}} = _info
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_rrt_type_pd =
        Enum.filter(beds, fn bed -> bed.rrt_type == "pd" end)
        |> length()

      {:ok, total_rrt_type_pd}
    end)
  end

  def dataloader_total_ventilator_in_use(ward, _params, %{context: %{loader: loader}} = _info) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_ventilator_in_use =
        Enum.filter(beds, fn bed -> bed.ventilation_type != nil end)
        |> length()

      {:ok, total_ventilator_in_use}
    end)
  end
end
