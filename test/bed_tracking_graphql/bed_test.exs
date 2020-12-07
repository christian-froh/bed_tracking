defmodule BedTrackingGraphql.BedTest do
  use BedTrackingWeb.ConnCase

  describe "update_bed" do
    setup do
      hospital = insert(:hospital)
      ward = insert(:ward, name: "lung ward", hospital: hospital)
      bed = insert(:bed, available: true, hospital: hospital, ward: ward)

      hospital_manager = insert(:hospital_manager, hospital: hospital)
      {:ok, %{token: token}} = BedTracking.Context.HospitalManager.login(hospital_manager.username, @password)

      %{
        token: token,
        hospital_manager: hospital_manager,
        hospital: hospital,
        ward: ward,
        bed: bed
      }
    end

    @query """
    mutation updateBed($input: UpdateBedInput!) {
      updateBed(input: $input) {
        bed {
          id
          covidStatus
        }
      }
    }
    """

    test "updates a bed", %{token: token, bed: bed} do
      response =
        graphql_query(
          query: @query,
          variables: %{
            input: %{
              id: bed.id,
              available: false,
              covid_status: "POSITIVE",
              level_of_care: "LEVEL_1",
              ventilation_type: "CPAP",
              reference: "1",
              date_of_admission: DateTime.utc_now(),
              source_of_admission: "ED",
              rrt_type: "HAEMOFILTRATION",
              use_tracheostomy: true
            }
          },
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["updateBed"]["bed"]["id"] == bed.id
    end

    test "returns validation error when one of the fields are missing", %{token: token, bed: bed} do
      response =
        graphql_query(
          query: @query,
          variables: %{
            input: %{
              id: bed.id,
              available: false,
              covid_status: "POSITIVE",
              level_of_care: "LEVEL_1",
              ventilation_type: "CPAP",
              reference: "1",
              date_of_admission: DateTime.utc_now(),
              source_of_admission: "ED",
              use_tracheostomy: true
            }
          },
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert [
               %{
                 "details" => "required",
                 "errorCode" => "ValidationError",
                 "field" => "rrt_type",
                 "message" => "Invalid parameter",
                 "path" => ["updateBed"],
                 "reason" => "can't be blank"
               }
             ] = response["errors"]
    end

    test "returns error when a field is set to nil which is mendatory when bed is occupied", %{token: token, bed: bed} do
      response =
        graphql_query(
          query: @query,
          variables: %{
            input: %{
              id: bed.id,
              available: false,
              covid_status: "POSITIVE",
              level_of_care: "LEVEL_1",
              ventilation_type: "CPAP",
              reference: "1",
              date_of_admission: DateTime.utc_now(),
              source_of_admission: "ED",
              rrt_type: "HAEMOFILTRATION",
              use_tracheostomy: true
            }
          },
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["updateBed"]["bed"]["id"] == bed.id

      new_response =
        graphql_query(
          query: @query,
          variables: %{input: %{id: bed.id, available: false, covid_status: nil}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert [
               %{
                 "details" => "required",
                 "errorCode" => "ValidationError",
                 "field" => "covid_status",
                 "message" => "Invalid parameter",
                 "path" => ["updateBed"],
                 "reason" => "can't be blank"
               }
             ] = new_response["errors"]
    end

    test "updates a bed when only one field is set", %{token: token, bed: bed} do
      response =
        graphql_query(
          query: @query,
          variables: %{
            input: %{
              id: bed.id,
              available: false,
              covid_status: "POSITIVE",
              level_of_care: "LEVEL_1",
              ventilation_type: "CPAP",
              reference: "1",
              date_of_admission: DateTime.utc_now(),
              source_of_admission: "ED",
              rrt_type: "HAEMOFILTRATION",
              use_tracheostomy: true
            }
          },
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert response["data"]["updateBed"]["bed"]["id"] == bed.id

      new_response =
        graphql_query(
          query: @query,
          variables: %{input: %{id: bed.id, available: false, covid_status: "NEGATIVE"}},
          token: token
        )
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert %{"updateBed" => %{"bed" => %{"covidStatus" => "NEGATIVE"}}} = new_response["data"]
    end
  end

  describe "discharge_patient" do
    setup do
      hospital = insert(:hospital)
      ward = insert(:ward, name: "lung ward", hospital: hospital)
      bed = insert(:bed, available: true, hospital: hospital, ward: ward)

      hospital_manager = insert(:hospital_manager, hospital: hospital)
      {:ok, %{token: token}} = BedTracking.Context.HospitalManager.login(hospital_manager.username, @password)

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
      bed = insert(:bed, available: false, initials: "CF", date_of_admission: DateTime.utc_now(), source_of_admission: "ed", hospital: hospital, ward: ward)

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
