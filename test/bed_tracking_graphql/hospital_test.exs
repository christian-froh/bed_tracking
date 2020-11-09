defmodule BedTrackingGraphql.HospitalTest do
  use BedTrackingWeb.ConnCase

  describe "get_hospital" do
    setup do
      hospital = insert(:hospital)
      hospital_manager = insert(:hospital_manager, hospital: hospital)

      ward_amber = insert(:ward, ward_type: "amber", hospital: hospital)
      ward_green = insert(:ward, ward_type: "green", hospital: hospital)
      ward_covid = insert(:ward, ward_type: "covid", hospital: hospital)

      insert(:bed, available: true, ward: ward_amber, hospital: hospital)
      insert(:bed, available: false, ward: ward_amber, hospital: hospital)
      insert(:bed, available: false, ward: ward_amber, hospital: hospital)

      insert(:bed, available: true, ward: ward_green, hospital: hospital)
      insert(:bed, available: false, ward: ward_green, hospital: hospital)
      insert(:bed, available: false, ward: ward_green, hospital: hospital)

      insert(:bed, available: true, ward: ward_covid, hospital: hospital)
      insert(:bed, available: false, ward: ward_covid, hospital: hospital)
      insert(:bed, available: false, ward: ward_covid, hospital: hospital)

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
               "unavailableBeds" => 6
             } = response["data"]["getHospital"]["hospital"]
    end
  end
end
