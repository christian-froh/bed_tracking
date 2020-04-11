defmodule BedTrackingGraphql.Schema.Ward do
  use BedTrackingGraphql.Schema.Base
  alias BedTracking.Context
  alias BedTracking.Repo

  ### OBJECTS ###
  object :ward do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:description, :string)
    field(:is_covid_ward, :boolean)

    field :total_beds, :integer do
      resolve(&Resolver.Ward.dataloader_total_beds/3)
    end

    field :available_beds, :integer do
      resolve(&Resolver.Ward.dataloader_available_beds/3)
    end

    field :unavailable_beds, :integer do
      resolve(&Resolver.Ward.dataloader_unavailable_beds/3)
    end

    field :total_covid_status_suspected, :integer do
      resolve(&Resolver.Ward.dataloader_total_covid_status_suspected/3)
    end

    field :total_covid_status_negative, :integer do
      resolve(&Resolver.Ward.dataloader_total_covid_status_negative/3)
    end

    field :total_covid_status_positive, :integer do
      resolve(&Resolver.Ward.dataloader_total_covid_status_positive/3)
    end

    field :total_level_of_care_level_one, :integer do
      resolve(&Resolver.Ward.dataloader_total_level_of_care_level_1/3)
    end

    field :total_level_of_care_level_two, :integer do
      resolve(&Resolver.Ward.dataloader_total_level_of_care_level_2/3)
    end

    field :total_level_of_care_level_three, :integer do
      resolve(&Resolver.Ward.dataloader_total_level_of_care_level_3/3)
    end

    field :total_ventilation_type_sv, :integer do
      resolve(&Resolver.Ward.dataloader_total_ventilation_type_sv/3)
    end

    field :total_ventilation_type_niv, :integer do
      resolve(&Resolver.Ward.dataloader_total_ventilation_type_niv/3)
    end

    field :total_ventilation_type_intubated, :integer do
      resolve(&Resolver.Ward.dataloader_total_ventilation_type_intubated/3)
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

  object :update_ward_payload do
    field :ward, :ward
  end

  object :remove_ward_payload do
    field :success, :boolean
  end

  object :update_number_of_beds_payload do
    field :ward, :ward
  end

  ### INPUTS ###
  input_object :create_ward_input do
    field(:name, non_null(:string))
    field(:description, :string)
    field(:is_covid_ward, :boolean)
  end

  input_object :update_ward_input do
    field(:id, non_null(:id))
    field(:name, :string)
    field(:description, :string)
    field(:is_covid_ward, :boolean)
  end

  input_object :remove_ward_input do
    field(:id, non_null(:id))
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

    field :update_ward, type: :update_ward_payload do
      arg(:input, non_null(:update_ward_input))
      resolve(&Resolver.Ward.update/2)
    end

    field :remove_ward, type: :remove_ward_payload do
      arg(:input, non_null(:remove_ward_input))
      resolve(&Resolver.Ward.remove/2)
    end

    field :update_number_of_beds, type: :update_number_of_beds_payload do
      arg(:input, non_null(:update_number_of_beds_input))
      resolve(&Resolver.Ward.update_number_of_beds/2)
    end
  end
end
