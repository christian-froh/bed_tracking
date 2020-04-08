defmodule BedTrackingGraphql.Schema.Ward do
  use BedTrackingGraphql.Schema.Base
  alias BedTracking.Context
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed

  ### OBJECTS ###
  object :ward do
    field(:id, non_null(:id))
    field(:short_name, non_null(:string))
    field(:long_name, :string)

    field :total_beds, :integer do
      resolve(&resolve_total_beds/3)
    end

    field :available_beds, :integer do
      resolve(&resolve_available_beds/3)
    end

    field :unavailable_beds, :integer do
      resolve(&resolve_unavailable_beds/3)
    end

    field :total_ventilator_in_use, :integer do
      resolve(&resolve_total_ventilator_in_use/3)
    end

    field :total_covid_status_suspected, :integer do
      resolve(&resolve_total_covid_status_suspected/3)
    end

    field :total_covid_status_negative, :integer do
      resolve(&resolve_total_covid_status_negative/3)
    end

    field :total_covid_status_positive, :integer do
      resolve(&resolve_total_covid_status_positive/3)
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

    field :hospital, non_null(:hospital) do
      resolve(dataloader(Repo))
    end
  end

  ### PAYLOADS ###
  object :create_ward_payload do
    field :ward, :ward
  end

  object :update_number_of_beds_payload do
    field :ward, :ward
  end

  ### INPUTS ###
  input_object :create_ward_input do
    field(:short_name, non_null(:string))
    field(:long_name, :string)
  end

  input_object :update_number_of_beds_input do
    field(:ward_id, non_null(:id))
    field(:number_of_total_beds, non_null(:integer))
    field(:number_of_available_beds, non_null(:integer))
  end

  ### MUTATIONS ###
  object :ward_mutations do
    field :create_ward, type: :create_ward_payload do
      arg(:input, non_null(:create_ward_input))
      resolve(&Resolver.Ward.create/2)
    end

    field :update_number_of_beds, type: :update_number_of_beds_payload do
      arg(:input, non_null(:update_number_of_beds_input))
      resolve(&Resolver.Ward.update_number_of_beds/2)
    end
  end

  ### FUNCTIONS ###
  defp resolve_total_beds(ward, _params, _info) do
    ward = Repo.preload(ward, :hospital)

    total_beds =
      case ward.hospital.use_management do
        true ->
          Bed
          |> Context.Bed.Query.where_ward_id(ward.id)
          |> Context.Bed.Query.count()
          |> Repo.one()

        _ ->
          ward.total_beds
      end

    {:ok, total_beds || 0}
  end

  defp resolve_available_beds(ward, _params, _info) do
    ward = Repo.preload(ward, :hospital)

    available_beds =
      case ward.hospital.use_management do
        true ->
          Bed
          |> Context.Bed.Query.where_ward_id(ward.id)
          |> Context.Bed.Query.where_available()
          |> Context.Bed.Query.count()
          |> Repo.one()

        _ ->
          ward.available_beds
      end

    {:ok, available_beds || 0}
  end

  defp resolve_unavailable_beds(ward, _params, _info) do
    ward = Repo.preload(ward, :hospital)

    unavailable_beds =
      case ward.hospital.use_management do
        true ->
          Bed
          |> Context.Bed.Query.where_ward_id(ward.id)
          |> Context.Bed.Query.where_not_available()
          |> Context.Bed.Query.count()
          |> Repo.one()

        _ ->
          ward.total_beds - ward.available_beds
      end

    {:ok, unavailable_beds || 0}
  end

  defp resolve_total_ventilator_in_use(ward, _params, _info) do
    total_ventilator_in_use =
      Bed
      |> Context.Bed.Query.where_ward_id(ward.id)
      |> Context.Bed.Query.where_ventilator_in_use()
      |> Context.Bed.Query.count()
      |> Repo.one()

    {:ok, total_ventilator_in_use || 0}
  end

  defp resolve_total_covid_status_suspected(ward, _params, _info) do
    total_covid_suspected =
      Bed
      |> Context.Bed.Query.where_ward_id(ward.id)
      |> Context.Bed.Query.where_covid_status("suspected")
      |> Context.Bed.Query.count()
      |> Repo.one()

    {:ok, total_covid_suspected || 0}
  end

  defp resolve_total_covid_status_negative(ward, _params, _info) do
    total_covid_negative =
      Bed
      |> Context.Bed.Query.where_ward_id(ward.id)
      |> Context.Bed.Query.where_covid_status("negative")
      |> Context.Bed.Query.count()
      |> Repo.one()

    {:ok, total_covid_negative || 0}
  end

  defp resolve_total_covid_status_positive(ward, _params, _info) do
    total_covid_positive =
      Bed
      |> Context.Bed.Query.where_ward_id(ward.id)
      |> Context.Bed.Query.where_covid_status("positive")
      |> Context.Bed.Query.count()
      |> Repo.one()

    {:ok, total_covid_positive || 0}
  end
end
