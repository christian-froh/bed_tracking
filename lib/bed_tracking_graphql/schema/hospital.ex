defmodule BedTrackingGraphql.Schema.Hospital do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :hospital do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:latitude, non_null(:float))
    field(:longitude, non_null(:float))
    field(:address, :string)

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

  ### QUERIES ###
  object :hospital_queries do
    field :get_hospitals, :get_hospitals_payload do
      resolve(&Resolver.Hospital.get_hospitals/2)
    end
  end
end
