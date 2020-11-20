defmodule BedTrackingGraphql.BedTest do
  use BedTrackingWeb.ConnCase

  describe "discharge_patient" do
    setup do
      hospital = insert(:hospital)
      ward = insert(:ward, name: "lung ward", hospital: hospital)
      bed = insert(:bed, available: true, hospital: hospital, ward: ward)

      hospital_manager = insert(:hospital_manager, hospital: hospital)
      {:ok, token} = BedTracking.Context.HospitalManager.login(hospital_manager.email, @password)

      %{
        token: token,
        hospital_manager: hospital_manager,
        hospital: hospital,
        ward: ward,
        bed: bed
      }
    end

    @query """
    mutation dischargePatient($input: DischargePatientInput!) {
      dischargePatient(input: $input) {
        success
      }
    }
    """

    test "discharges a patient", %{token: token, hospital: hospital, ward: ward} do
      bed = insert(:bed, available: false, initials: "CF", hospital: hospital, ward: ward)

      response =
        graphql_query(
          query: @query,
          variables: %{input: %{id: bed.id, reason: "DEATH"}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      bed = BedTracking.Repo.get(BedTracking.Repo.Bed, bed.id)

      assert bed.available == true
      assert bed.initials == nil
      assert response["data"]["dischargePatient"]["success"] == true
    end

    test "moves the patient to another bed when reason is internal_icu", %{token: token, hospital: hospital, ward: ward, bed: other_bed} do
      bed = insert(:bed, available: false, initials: "CF", hospital: hospital, ward: ward)

      response =
        graphql_query(
          query: @query,
          variables: %{input: %{id: bed.id, reason: "INTERNAL_ICU", bed_id: other_bed.id}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      bed = BedTracking.Repo.get(BedTracking.Repo.Bed, bed.id)

      assert bed.available == true
      assert bed.initials == nil

      other_bed = BedTracking.Repo.get(BedTracking.Repo.Bed, other_bed.id)

      assert other_bed.available == false
      assert other_bed.initials == "CF"

      assert response["data"]["dischargePatient"]["success"] == true
    end

    test "returns error when reason is internal_icu and there is no bed_id", %{token: token, hospital: hospital, ward: ward} do
      bed = insert(:bed, available: false, initials: "CF", hospital: hospital, ward: ward)

      response =
        graphql_query(
          query: @query,
          variables: %{input: %{id: bed.id, reason: "INTERNAL_ICU"}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert [
               %{
                 "errorCode" => "UnhandledError",
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Something went wrong",
                 "path" => ["dischargePatient"],
                 "unhandledError" => "bed_id is missing"
               }
             ] = response["errors"]
    end
  end
end
