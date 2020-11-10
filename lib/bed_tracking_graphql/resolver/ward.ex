defmodule BedTrackingGraphql.Resolver.Ward do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Hospital

  def create(%{input: %{name: _name, ward_type: _ward_type} = params}, info) do
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

  def dataloader_total_ventilator_type(
        ward,
        _params,
        %{context: %{loader: loader}} = _info,
        ventilator_type
      ) do
    loader
    |> Dataloader.load(Repo, {:many, Bed}, ward_id: ward.id)
    |> on_load(fn loader ->
      beds = Dataloader.get(loader, Repo, {:many, Bed}, ward_id: ward.id)

      total_ventilator_type =
        Enum.filter(beds, fn bed -> bed.ventilator_type == ventilator_type end)
        |> length()

      {:ok, total_ventilator_type}
    end)
  end
end
