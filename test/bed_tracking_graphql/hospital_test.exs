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

      token = hospital_manager.hospital_id

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

          totalVentilatorTypeNone
          totalVentilatorTypeSv
          totalVentilatorTypeInvasive

          totalNumberOfCritcareNurses
          totalNumberOfOtherRns
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
               "totalVentilatorTypeNone" => 1,
               "totalVentilatorTypeSv" => 1,
               "totalVentilatorTypeInvasive" => 4,
               "totalNumberOfCritcareNurses" => 23,
               "totalNumberOfOtherRns" => 10
             } = response["data"]["getHospital"]["hospital"]
    end
  end
end
