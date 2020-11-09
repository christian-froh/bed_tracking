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

    field :total_covid_status_green, :integer do
      resolve(&Resolver.Ward.dataloader_total_covid_status_green/3)
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

    field :total_rrt_type_none, :integer do
      resolve(&Resolver.Ward.dataloader_total_rrt_type_none/3)
    end

    field :total_rrt_type_risk_of_next_twenty_four_h, :integer do
      resolve(&Resolver.Ward.dataloader_total_rrt_type_risk_of_next_twenty_four_h/3)
    end

    field :total_rrt_type_haemodialysis, :integer do
      resolve(&Resolver.Ward.dataloader_total_rrt_type_haemodialysis/3)
    end

    field :total_rrt_type_haemofiltration, :integer do
      resolve(&Resolver.Ward.dataloader_total_rrt_type_haemofiltration/3)
    end

    field :total_rrt_type_pd, :integer do
      resolve(&Resolver.Ward.dataloader_total_rrt_type_pd/3)
    end

    field :total_ventilator_in_use, :integer do
      resolve(&Resolver.Ward.dataloader_total_ventilator_in_use/3)
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
  end
end
