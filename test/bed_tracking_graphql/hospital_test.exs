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

      {:ok, %{token: token}} = BedTracking.Context.HospitalManager.login(hospital_manager.username, @password)

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

          hospitalManagers {
            id
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

    test "returns the latest updated_at or latest updated_by", %{token: token, hospital: hospital, hospital_manager: hospital_manager} do
      hospital_manager2 = insert(:hospital_manager, hospital: hospital)

      ward_amber =
        insert(:ward, updated_by_hospital_manager: hospital_manager, hospital: hospital, updated_at: DateTime.add(DateTime.utc_now(), -1000, :second))

      ward_covid = insert(:ward, updated_by_hospital_manager: hospital_manager2, hospital: hospital, updated_at: DateTime.add(DateTime.utc_now(), 0, :second))

      insert(:bed,
        available: false,
        updated_by_hospital_manager: hospital_manager2,
        ward: ward_amber,
        hospital: hospital,
        updated_at: DateTime.add(DateTime.utc_now(), -500, :second)
      )

      ward_amber_bed2 =
        insert(:bed,
          available: false,
          updated_by_hospital_manager: hospital_manager,
          ward: ward_amber,
          hospital: hospital,
          updated_at: DateTime.add(DateTime.utc_now(), -200, :second)
        )

      insert(:bed,
        available: false,
        updated_by_hospital_manager: hospital_manager,
        ward: ward_covid,
        hospital: hospital,
        updated_at: DateTime.add(DateTime.utc_now(), -200, :second)
      )

      insert(:bed,
        available: false,
        updated_by_hospital_manager: hospital_manager2,
        ward: ward_covid,
        hospital: hospital,
        updated_at: DateTime.add(DateTime.utc_now(), -500, :second)
      )

      response =
        graphql_query(query: @query, token: token)
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      wards_result = response["data"]["getHospital"]["hospital"]["wards"]

      ward_covid_result = Enum.find(wards_result, fn %{"id" => id} -> id == ward_covid.id end)
      {:ok, datetime, 0} = DateTime.from_iso8601(ward_covid_result["lastUpdatedAtOfWardOrBeds"])
      assert datetime == ward_covid.updated_at
      assert ward_covid_result["lastUpdatedByHospitalManagerOfWardOrBeds"]["id"] == hospital_manager2.id

      ward_amber_result = Enum.find(wards_result, fn %{"id" => id} -> id == ward_amber.id end)
      {:ok, datetime, 0} = DateTime.from_iso8601(ward_amber_result["lastUpdatedAtOfWardOrBeds"])
      assert datetime == ward_amber_bed2.updated_at
      assert ward_amber_result["lastUpdatedByHospitalManagerOfWardOrBeds"]["id"] == hospital_manager.id
    end

    test "returns hospital managers", %{token: token, hospital: hospital} do
      insert(:hospital_manager, hospital: hospital)

      response =
        graphql_query(query: @query, token: token)
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      hospital_managers = response["data"]["getHospital"]["hospital"]["hospitalManagers"]
      assert length(hospital_managers) == 2
    end

    test "doesnt return deleted hospital managers", %{token: token, hospital: hospital} do
      insert(:hospital_manager, deleted_at: DateTime.utc_now(), hospital: hospital)

      response =
        graphql_query(query: @query, token: token)
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      hospital_managers = response["data"]["getHospital"]["hospital"]["hospitalManagers"]
      assert length(hospital_managers) == 1
    end
  end
end
