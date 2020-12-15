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
        isChangedPassword
      }
    }
    """

    test "logging in the hospital manager", %{hospital_manager: hospital_manager} do
      response =
        graphql_public_query(
          query: @query,
          variables: %{input: %{username: hospital_manager.username, password: @password}}
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["loginHospitalManager"]["token"] != nil
      assert response["data"]["loginHospitalManager"]["isChangedPassword"] == false
    end

    test "username works case sensitive", %{hospital: hospital} do
      insert(:hospital_manager,
        username: "thomas.mueller@example.com",
        hospital: hospital
      )

      response =
        graphql_public_query(
          query: @query,
          variables: %{input: %{username: "Thomas.Mueller@example.com", password: @password}}
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
          variables: %{input: %{username: hospital_manager.username, password: "wrong_pw"}}
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
          variables: %{input: %{username: "wrong_username", password: @password}}
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

  describe "change_password" do
    setup do
      hospital = insert(:hospital)
      hospital_manager = insert(:hospital_manager, hospital: hospital)

      {:ok, %{token: token}} = BedTracking.Context.HospitalManager.login(hospital_manager.username, @password)

      %{hospital_manager: hospital_manager, hospital: hospital, token: token}
    end

    @query """
    mutation changePassword($input: ChangePasswordInput!) {
      changePassword(input: $input) {
        token
      }
    }
    """

    test "changing password returns new token and sets is_changed_password to true", %{token: token, hospital_manager: hospital_manager} do
      response =
        graphql_query(
          query: @query,
          variables: %{input: %{old_password: @password, new_password: "123456789"}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["changePassword"]["token"] != nil

      reloaded_hospital_manager = BedTracking.Repo.get(BedTracking.Repo.HospitalManager, hospital_manager.id)
      assert reloaded_hospital_manager.is_changed_password == true
    end

    test "wrong old password returns error", %{token: token} do
      response =
        graphql_query(
          query: @query,
          variables: %{input: %{old_password: "wrong password", new_password: "123456789"}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert [
               %{
                 "errorCode" => "WrongPasswordError",
                 "message" => "Wrong password",
                 "path" => ["changePassword"]
               }
             ] = response["errors"]
    end
  end

  describe "reset_password" do
    setup do
      hospital = insert(:hospital)
      hospital_manager = insert(:hospital_manager, hospital: hospital)
      hospital_manager_admin = insert(:hospital_manager, is_admin: true, hospital: hospital)

      {:ok, %{token: token}} = BedTracking.Context.HospitalManager.login(hospital_manager_admin.username, @password)

      %{hospital_manager_admin: hospital_manager_admin, hospital_manager: hospital_manager, hospital: hospital, token: token}
    end

    @query """
    mutation resetPassword($input: ResetPasswordInput!) {
      resetPassword(input: $input) {
        success
      }
    }
    """

    test "resetting password returns success = true and sets is_changed_password to false", %{
      token: token,
      hospital_manager: hospital_manager
    } do
      response =
        graphql_query(
          query: @query,
          variables: %{input: %{hospital_manager_id: hospital_manager.id, new_password: "123456789"}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["resetPassword"]["success"] == true

      reloaded_hospital_manager = BedTracking.Repo.get(BedTracking.Repo.HospitalManager, hospital_manager.id)
      assert reloaded_hospital_manager.is_changed_password == false
    end

    test "returns error when hospital manager is not an admin", %{hospital: hospital, hospital_manager: hospital_manager} do
      hospital_manager_non_admin = insert(:hospital_manager, is_admin: false, hospital: hospital)

      {:ok, %{token: token}} = BedTracking.Context.HospitalManager.login(hospital_manager_non_admin.username, @password)

      response =
        graphql_query(
          query: @query,
          variables: %{input: %{hospital_manager_id: hospital_manager.id, new_password: "123456789"}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert [
               %{
                 "errorCode" => "AuthenticationError",
                 "message" => "Authentication failed",
                 "path" => ["resetPassword"]
               }
             ] = response["errors"]
    end
  end
end
