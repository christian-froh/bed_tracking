defmodule BedTrackingGraphql.HospitalTest do
  use BedTrackingWeb.ConnCase

  describe "get_hospital" do
    setup do
      hospital = insert(:hospital)
      hospital_manager = insert(:hospital_manager, hospital: hospital)
      token = hospital_manager.hospital_id

      %{token: token, hospital_manager: hospital_manager, hospital: hospital}
    end

    @query """
    query getHospital {
      getHospital {
        hospital {
          id
          name
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
  end
end
