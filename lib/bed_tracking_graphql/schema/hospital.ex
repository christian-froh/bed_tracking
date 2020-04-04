defmodule BedTrackingGraphql.Schema.Hospital do
  use BedTrackingGraphql.Schema.Base
  alias BedTracking.Context
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Ward

  ### OBJECTS ###
  object :hospital do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:latitude, non_null(:float))
    field(:longitude, non_null(:float))
    field(:address, :string)
    field(:use_management, :boolean)

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
      resolve(
        dataloader(Repo, :beds,
          args: %{
            query_fun: fn query ->
              Context.Bed.Query.ordered_by(query, :asc, :inserted_at)
            end
          }
        )
      )
    end

    field :wards, list_of(:ward) do
      resolve(
        dataloader(Repo, :wards,
          args: %{
            query_fun: fn query ->
              Context.Ward.Query.ordered_by(query, :asc, :short_name)
            end
          }
        )
      )
    end

    field :hospital_managers, list_of(:hospital_manager) do
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

  object :create_hospital_payload do
    field :hospital, :hospital
  end

  object :use_management_system_payload do
    field :hospital, :hospital
  end

  ### INPUTS ###
  input_object :create_hospital_input do
    field(:name, non_null(:string))
    field(:latitude, non_null(:float))
    field(:longitude, non_null(:float))
    field(:address, :string)
  end

  input_object :use_management_system_input do
    field(:use_management, non_null(:boolean))
  end

  ### QUERIES ###
  object :hospital_queries do
    field :get_hospitals, :get_hospitals_payload do
      resolve(&Resolver.Hospital.get_hospitals/2)
    end

    field :get_hospital, :get_hospital_payload do
      resolve(&Resolver.Hospital.get_hospital/2)
    end
  end

  ### MUTATIONS ###
  object :hospital_mutations do
    field :create_hospital, type: :create_hospital_payload do
      arg(:input, non_null(:create_hospital_input))
      resolve(&Resolver.Hospital.create_hospital/2)
    end

    field :use_management_system, type: :use_management_system_payload do
      arg(:input, non_null(:use_management_system_input))
      resolve(&Resolver.Hospital.use_management_system/2)
    end
  end

  ### FUNCTIONS ###
  defp resolve_total_beds(hospital, _params, _info) do
    total_beds =
      case hospital.use_management do
        true ->
          Bed
          |> Context.Bed.Query.where_hospital_id(hospital.id)
          |> Context.Bed.Query.where_active()
          |> Context.Bed.Query.count()
          |> Repo.one()

        _ ->
          Ward
          |> Context.Ward.Query.where_hospital_id(hospital.id)
          |> Context.Ward.Query.total_beds()
          |> Repo.one()
      end

    {:ok, total_beds || 0}
  end

  defp resolve_available_beds(hospital, _params, _info) do
    available_beds =
      case hospital.use_management do
        true ->
          Bed
          |> Context.Bed.Query.where_hospital_id(hospital.id)
          |> Context.Bed.Query.where_active()
          |> Context.Bed.Query.where_available()
          |> Context.Bed.Query.count()
          |> Repo.one()

        _ ->
          Ward
          |> Context.Ward.Query.where_hospital_id(hospital.id)
          |> Context.Ward.Query.available_beds()
          |> Repo.one()
      end

    {:ok, available_beds || 0}
  end

  defp resolve_unavailable_beds(hospital, _params, _info) do
    unavailable_beds =
      case hospital.use_management do
        true ->
          Bed
          |> Context.Bed.Query.where_hospital_id(hospital.id)
          |> Context.Bed.Query.where_active()
          |> Context.Bed.Query.where_not_available()
          |> Context.Bed.Query.count()
          |> Repo.one()

        _ ->
          Ward
          |> Context.Ward.Query.where_hospital_id(hospital.id)
          |> Context.Ward.Query.unavailable_beds()
          |> Repo.one()
      end

    {:ok, unavailable_beds || 0}
  end
end
