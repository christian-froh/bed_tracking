defmodule BedTrackingGraphql.HospitalManagerTest do
  use BedTrackingWeb.ConnCase

  describe "login_hospital_manager" do
    setup do
      hospital = insert(:hospital)
      hospital_manager = insert(:hospital_manager, hospital: hospital)

      %{hospital_manager: hospital_manager, hospital: hospital}
    end

    @query """
    mutation loginHospitalManager($input: LoginHospitalManagerInput!) {
      loginHospitalManager(input: $input) {
        token
      }
    }
    """

    test "logging in the hospital manager", %{hospital_manager: hospital_manager} do
      response =
        graphql_public_query(
          query: @query,
          variables: %{input: %{email: hospital_manager.email, password: @password}}
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["loginHospitalManager"]["token"] != nil
    end

    test "email works case sensitive", %{hospital: hospital} do
      insert(:hospital_manager,
        email: "thomas.mueller@example.com",
        hospital: hospital
      )

      response =
        graphql_public_query(
          query: @query,
          variables: %{input: %{email: "Thomas.Mueller@example.com", password: @password}}
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["loginHospitalManager"]["token"] != nil
    end

    test "returns error when password is wrong", %{hospital_manager: hospital_manager} do
      response =
        graphql_public_query(
          query: @query,
          variables: %{input: %{email: hospital_manager.email, password: "wrong_pw"}}
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert [
               %{
                 "errorCode" => "AuthenticationError",
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Authentication failed",
                 "path" => ["loginHospitalManager"]
               }
             ] = response["errors"]
    end

    test "returns error when hospital manager doesnt exist" do
      response =
        graphql_public_query(
          query: @query,
          variables: %{input: %{email: "wrong_email", password: @password}}
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert [
               %{
                 "errorCode" => "AuthenticationError",
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Authentication failed",
                 "path" => ["loginHospitalManager"]
               }
             ] = response["errors"]
    end
  end
end
