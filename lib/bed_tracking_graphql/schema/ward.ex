defmodule BedTrackingGraphql.Schema.Ward do
  use BedTrackingGraphql.Schema.Base
  alias BedTracking.Context

  ### OBJECTS ###
  object :ward do
    field(:id, non_null(:id))
    field(:name, :string)

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

    field :hospital, non_null(:hospital) do
      resolve(dataloader(Repo))
    end
  end

  ### PAYLOADS ###
  object :create_ward_payload do
    field :ward, :ward
  end

  ### INPUTS ###
  input_object :create_ward_input do
    field(:name, non_null(:string))
  end

  ### MUTATIONS ###
  object :ward_mutations do
    field :create_ward, type: :create_ward_payload do
      arg(:input, non_null(:create_ward_input))
      resolve(&Resolver.Ward.create/2)
    end
  end

  ### FUNCTIONS ###
  defp resolve_total_beds(ward, _params, _info) do
    total_beds =
      Bed
      |> Context.Bed.Query.where_ward_id(ward.id)
      |> Context.Bed.Query.where_active()
      |> Context.Bed.Query.count()
      |> Repo.one()

    {:ok, total_beds}
  end

  defp resolve_available_beds(ward, _params, _info) do
    available_beds =
      Bed
      |> Context.Bed.Query.where_ward_id(ward.id)
      |> Context.Bed.Query.where_active()
      |> Context.Bed.Query.where_available()
      |> Context.Bed.Query.count()
      |> Repo.one()

    {:ok, available_beds}
  end

  defp resolve_unavailable_beds(ward, _params, _info) do
    unavailable_beds =
      Bed
      |> Context.Bed.Query.where_ward_id(ward.id)
      |> Context.Bed.Query.where_active()
      |> Context.Bed.Query.where_not_available()
      |> Context.Bed.Query.count()
      |> Repo.one()

    {:ok, unavailable_beds}
  end
end
