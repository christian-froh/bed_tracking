defmodule BedTrackingGraphql.Schema.Hospital do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :hospital do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:latitude, non_null(:float))
    field(:longitude, non_null(:float))
    field(:address, :string)

    field :total_beds, :integer do
      resolve(&resolve_total_beds/3)
    end

    field :available_beds, :integer do
      resolve(&resolve_available_beds/3)
    end

    field :unavailable_beds, :integer do
      resolve(&resolve_unavailable_beds/3)
    end

    field :beds, list_of(:bed) do
      resolve(dataloader(Repo))
    end

    field :facilities, list_of(:facility) do
      resolve(dataloader(Repo))
    end
  end

  ### PAYLOADS ###
  object :get_hospitals_payload do
    field :hospitals, list_of(:hospital)
  end

  object :get_hospital_payload do
    field :hospital, :hospital
  end

  ### INPUTS ###
  input_object :get_hospital_input do
    field(:hospital_id, non_null(:id))
  end

  ### QUERIES ###
  object :hospital_queries do
    field :get_hospitals, :get_hospitals_payload do
      resolve(&Resolver.Hospital.get_hospitals/2)
    end

    field :get_hospital, :get_hospital_payload do
      arg(:input, non_null(:get_hospital_input))
      resolve(&Resolver.Hospital.get_hospital/2)
    end
  end

  ### FUNCTIONS ###
  defp resolve_total_beds(hospital, _params, _info) do
    hospital = BedTracking.Repo.preload(hospital, :beds)
    total_beds = length(hospital.beds)
    {:ok, total_beds}
  end

  defp resolve_available_beds(hospital, _params, _info) do
    hospital = BedTracking.Repo.preload(hospital, :beds)

    available_beds = length(Enum.filter(hospital.beds, fn bed -> bed.available end))
    {:ok, available_beds}
  end

  defp resolve_unavailable_beds(hospital, _params, _info) do
    hospital = BedTracking.Repo.preload(hospital, :beds)

    unavailable_beds = length(Enum.filter(hospital.beds, fn bed -> bed.available == false end))
    {:ok, unavailable_beds}
  end
end
