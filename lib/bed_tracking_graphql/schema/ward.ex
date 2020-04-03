defmodule BedTrackingGraphql.Schema.Ward do
  use BedTrackingGraphql.Schema.Base
  alias BedTracking.Context

  ### OBJECTS ###
  object :ward do
    field(:id, non_null(:id))
    field(:name, :string)

    field(:total_beds, :integer)
    field(:available_beds, :integer)

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

  object :update_number_of_beds_payload do
    field :ward, :ward
  end

  ### INPUTS ###
  input_object :create_ward_input do
    field(:name, non_null(:string))
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
  defp resolve_unavailable_beds(ward, _params, _info) do
    unavailable_beds = ward.total_beds - ward.available_beds

    {:ok, unavailable_beds}
  end
end
