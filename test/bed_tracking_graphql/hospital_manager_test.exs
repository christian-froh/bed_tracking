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
        hospitalManager {
          id
          firstname
          lastname
          email

          hospital {
            id
          }
        }
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

      assert response["data"]["loginHospitalManager"]["hospitalManager"]["firstname"] ==
               hospital_manager.firstname

      assert response["data"]["loginHospitalManager"]["hospitalManager"]["hospital"]["id"] ==
               hospital_manager.hospital.id
    end

    test "email works case sensitive", %{hospital: hospital} do
      hospital_manager =
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

      assert response["data"]["loginHospitalManager"]["hospitalManager"]["firstname"] ==
               hospital_manager.firstname

      assert response["data"]["loginHospitalManager"]["hospitalManager"]["hospital"]["id"] ==
               hospital_manager.hospital.id
    end

    # test "returns error when password is wrong", %{dealer: dealer} do
    #   response =
    #     graphql_public_query(
    #       query: @query,
    #       variables: %{input: %{email: dealer.email, password: "wrong_pw"}}
    #     )
    #     |> BedTrackingWeb.Endpoint.call([])
    #     |> Map.get(:resp_body)
    #     |> Jason.decode!()

    #   assert [
    #            %{
    #              "__typename" => "AuthenticationError",
    #              "message" => "Authentication failed",
    #              "path" => ["login"]
    #            }
    #          ] = response["errors"]
    # end

    # test "returns error when dealer doesnt exist" do
    #   response =
    #     graphql_public_query(
    #       query: @query,
    #       variables: %{input: %{email: "wrong_email", password: @password}}
    #     )
    #     |> BedTrackingWeb.Endpoint.call([])
    #     |> Map.get(:resp_body)
    #     |> Jason.decode!()

    #   assert [
    #            %{
    #              "__typename" => "AuthenticationError",
    #              "message" => "Authentication failed",
    #              "path" => ["login"]
    #            }
    #          ] = response["errors"]
    # end

    # test "set the context to en when the header is en", %{dealer: dealer} do
    #   response =
    #     graphql_public_query(
    #       query: @query,
    #       variables: %{input: %{email: dealer.email, password: @password}},
    #       locale: "en"
    #     )
    #     |> BedTrackingWeb.Endpoint.call([])

    #   private = Map.get(response, :private)
    #   assert get_in(private, [:absinthe, :context, :locale]) == "en"
    # end

    # test "set the context to de when the header is de", %{dealer: dealer} do
    #   response =
    #     graphql_public_query(
    #       query: @query,
    #       variables: %{input: %{email: dealer.email, password: @password}},
    #       locale: "de"
    #     )
    #     |> BedTrackingWeb.Endpoint.call([])

    #   private = Map.get(response, :private)
    #   assert get_in(private, [:absinthe, :context, :locale]) == "de"
    # end
  end
end
