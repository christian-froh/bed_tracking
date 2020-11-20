defmodule BedTrackingGraphql.HospitalTest do
  use BedTrackingWeb.ConnCase

  describe "get_hospital" do
    setup do
      hospital = insert(:hospital)
      hospital_manager = insert(:hospital_manager, hospital: hospital)

      ward_amber = insert(:ward, ward_type: "amber", number_of_critcare_nurses: 10, number_of_other_rns: 0, hospital: hospital)
      ward_green = insert(:ward, ward_type: "green", number_of_critcare_nurses: 5, number_of_other_rns: 10, hospital: hospital)
      ward_covid = insert(:ward, ward_type: "covid", number_of_critcare_nurses: 8, number_of_other_rns: nil, hospital: hospital)

      insert(:bed, available: true, ward: ward_amber, hospital: hospital)
      insert(:bed, available: false, ventilation_type: "invasive", rrt_type: "risk_of_next_twenty_four_h", ward: ward_amber, hospital: hospital)
      insert(:bed, available: false, ventilation_type: "sv", rrt_type: "pd", ward: ward_amber, hospital: hospital)

      insert(:bed, available: true, ward: ward_green, hospital: hospital)
      insert(:bed, available: false, ventilation_type: "invasive", rrt_type: "risk_of_next_twenty_four_h", ward: ward_green, hospital: hospital)
      insert(:bed, available: false, ventilation_type: "none", rrt_type: "pd", ward: ward_green, hospital: hospital)

      insert(:bed, available: true, ward: ward_covid, hospital: hospital)
      insert(:bed, available: false, ventilation_type: "invasive", rrt_type: "haemodialysis", ward: ward_covid, hospital: hospital)
      insert(:bed, available: false, ventilation_type: "invasive", rrt_type: "haemodialysis", ward: ward_covid, hospital: hospital)

      {:ok, token} = BedTracking.Context.HospitalManager.login(hospital_manager.email, @password)

      %{token: token, hospital_manager: hospital_manager, hospital: hospital}
    end

    @query """
    query getHospital {
      getHospital {
        hospital {
          id
          name
          totalBeds
          availableBeds
          unavailableBeds
          totalAmberBeds
          totalAvailableAmberBeds
          totalGreenBeds
          totalAvailableGreenBeds
          totalCovidBeds
          totalAvailableCovidBeds

          totalRrtTypeRiskOfNextTwentyFourH
          totalRrtTypeHaemodialysis
          totalRrtTypePd

          totalVentilationTypeNone
          totalVentilationTypeSv
          totalVentilationTypeInvasive

          totalNumberOfCritcareNurses
          totalNumberOfOtherRns

          wards {
            id
            lastUpdatedAtOfWardOrBeds
            lastUpdatedByHospitalManagerOfWardOrBeds {
              id
            }
          }
        }
      }
    }
    """

    test "get hospital", %{token: token, hospital: hospital} do
      response =
        graphql_query(query: @query, token: token)
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["getHospital"]["hospital"]["name"] == hospital.name
    end

    test "hospital with correct bed availability for different ward types", %{token: token} do
      response =
        graphql_query(query: @query, token: token)
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert %{
               "availableBeds" => 3,
               "name" => "Free Royal Hospital",
               "totalAmberBeds" => 3,
               "totalAvailableAmberBeds" => 1,
               "totalAvailableCovidBeds" => 1,
               "totalAvailableGreenBeds" => 1,
               "totalBeds" => 9,
               "totalCovidBeds" => 3,
               "totalGreenBeds" => 3,
               "unavailableBeds" => 6,
               "totalRrtTypeRiskOfNextTwentyFourH" => 2,
               "totalRrtTypeHaemodialysis" => 2,
               "totalRrtTypePd" => 2,
               "totalVentilationTypeNone" => 1,
               "totalVentilationTypeSv" => 1,
               "totalVentilationTypeInvasive" => 4,
               "totalNumberOfCritcareNurses" => 23,
               "totalNumberOfOtherRns" => 10
             } = response["data"]["getHospital"]["hospital"]
    end

    # test "returns the latest updated_at or latest updated_by", %{token: token, hospital: hospital, hospital_manager: hospital_manager} do
    #   hospital_manager2 = insert(:hospital_manager, hospital: hospital)

    #   ward_amber =
    #     insert(:ward, updated_by_hospital_manager: hospital_manager, hospital: hospital, updated_at: DateTime.add(DateTime.utc_now(), -1000, :second))

    #   ward_covid = insert(:ward, updated_by_hospital_manager: hospital_manager2, hospital: hospital, updated_at: DateTime.add(DateTime.utc_now(), 0, :second))

    #   ward_amber_bed1 =
    #     insert(:bed,
    #       available: false,
    #       updated_by_hospital_manager: hospital_manager2,
    #       ward: ward_amber,
    #       hospital: hospital,
    #       updated_at: DateTime.add(DateTime.utc_now(), -500, :second)
    #     )

    #   ward_amber_bed2 =
    #     insert(:bed,
    #       available: false,
    #       updated_by_hospital_manager: hospital_manager,
    #       ward: ward_amber,
    #       hospital: hospital,
    #       updated_at: DateTime.add(DateTime.utc_now(), -200, :second)
    #     )

    #   ward_covid_bed1 =
    #     insert(:bed,
    #       available: false,
    #       updated_by_hospital_manager: hospital_manager,
    #       ward: ward_covid,
    #       hospital: hospital,
    #       updated_at: DateTime.add(DateTime.utc_now(), -200, :second)
    #     )

    #   ward_covid_bed2 =
    #     insert(:bed,
    #       available: false,
    #       updated_by_hospital_manager: hospital_manager2,
    #       ward: ward_covid,
    #       hospital: hospital,
    #       updated_at: DateTime.add(DateTime.utc_now(), -500, :second)
    #     )

    #   response =
    #     graphql_query(query: @query, token: token)
    #     |> BedTrackingWeb.Endpoint.call([])
    #     |> Map.get(:resp_body)
    #     |> Jason.decode!()

    #   assert [
    #            %{
    #              "id" => "f182de48-7153-4a88-b286-328dc42e61b2",
    #              "lastUpdatedAtOfWardOrBeds" => "2020-11-20T20:09:00.657249Z",
    #              "lastUpdatedByHospitalManagerOfWardOrBeds" => %{"id" => "dfc1c0f6-2328-4ff8-9b2f-1db55d5538e8"}
    #            },
    #            %{
    #              "id" => "8d2709d2-74c3-420c-8daa-1e05a6d9c14e",
    #              "lastUpdatedAtOfWardOrBeds" => "2020-11-20T20:09:00.692500Z",
    #              "lastUpdatedByHospitalManagerOfWardOrBeds" => %{"id" => "ad4349b1-79c7-4cf8-8d3d-af00a2614260"}
    #            },
    #            %{
    #              "id" => "9c95894f-3e70-4a21-b80d-5ce8c63b7f20",
    #              "lastUpdatedAtOfWardOrBeds" => "2020-11-20T20:09:00.715293Z",
    #              "lastUpdatedByHospitalManagerOfWardOrBeds" => %{"id" => "c6c269ad-f8ab-4e64-94b3-8da9ba5f7e81"}
    #            },
    #            %{
    #              "id" => "08b41e26-4777-44fb-8efa-df8a2b7129c9",
    #              "lastUpdatedAtOfWardOrBeds" => "2020-11-20T20:05:41.005679Z",
    #              "lastUpdatedByHospitalManagerOfWardOrBeds" => %{"id" => "d0f30449-253e-482b-9656-9e65b639d2aa"}
    #            },
    #            %{
    #              "id" => "bf7dc76f-cb30-493b-b8cd-e04aac16677f",
    #              "lastUpdatedAtOfWardOrBeds" => "2020-11-20T20:09:00.995776Z",
    #              "lastUpdatedByHospitalManagerOfWardOrBeds" => %{"id" => "44d9ec03-24ab-496d-9554-61d72ac3a2ba"}
    #            }
    #          ] = response["data"]["getHospital"]["hospital"]["wards"]
    # end
  end
end
