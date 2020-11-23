defmodule BedTrackingGraphql.ReportTest do
  use BedTrackingWeb.ConnCase

  describe "get_report" do
    setup do
      hospital = insert(:hospital)
      hospital_manager = insert(:hospital_manager, hospital: hospital)

      ward_amber = insert(:ward, ward_type: "amber", is_surge_ward: true, number_of_critcare_nurses: 10, number_of_other_rns: 0, hospital: hospital)
      ward_green = insert(:ward, ward_type: "green", is_surge_ward: false, number_of_critcare_nurses: 5, number_of_other_rns: 10, hospital: hospital)
      ward_covid = insert(:ward, ward_type: "covid", is_surge_ward: true, number_of_critcare_nurses: 8, number_of_other_rns: nil, hospital: hospital)

      insert(:bed,
        available: true,
        ward: ward_amber,
        hospital: hospital
      )

      insert(:bed,
        available: false,
        date_of_admission: DateTime.utc_now(),
        covid_status: "green",
        ventilation_type: "invasive",
        rrt_type: "risk_of_next_twenty_four_h",
        ward: ward_amber,
        hospital: hospital
      )

      insert(:bed,
        available: false,
        date_of_admission: DateTime.utc_now(),
        covid_status: "green",
        ventilation_type: "bipap",
        rrt_type: "pd",
        ward: ward_amber,
        hospital: hospital
      )

      insert(:bed,
        available: true,
        ward: ward_green,
        hospital: hospital
      )

      insert(:bed,
        available: false,
        date_of_admission: DateTime.utc_now(),
        covid_status: "negative",
        ventilation_type: "invasive",
        rrt_type: "risk_of_next_twenty_four_h",
        ward: ward_green,
        hospital: hospital
      )

      insert(:bed,
        available: false,
        date_of_admission: DateTime.utc_now(),
        covid_status: "negative",
        ventilation_type: "cpap",
        rrt_type: "pd",
        ward: ward_green,
        hospital: hospital
      )

      insert(:bed,
        available: true,
        ward: ward_covid,
        hospital: hospital
      )

      insert(:bed,
        available: false,
        date_of_admission: DateTime.add(DateTime.utc_now(), -172_800, :second),
        covid_status: "positive",
        ventilation_type: "invasive",
        rrt_type: "haemodialysis",
        ward: ward_covid,
        hospital: hospital
      )

      insert(:bed,
        available: false,
        date_of_admission: DateTime.add(DateTime.utc_now(), -172_800, :second),
        covid_status: "positive",
        ventilation_type: "invasive",
        rrt_type: "haemodialysis",
        ward: ward_covid,
        hospital: hospital
      )

      insert(:discharge, reason: "death", ward: ward_covid, hospital: hospital)
      insert(:discharge, reason: "external_ward", ward: ward_amber, hospital: hospital)
      insert(:discharge, reason: "death", inserted_at: DateTime.add(DateTime.utc_now(), -172_800, :second), ward: ward_covid, hospital: hospital)

      {:ok, token} = BedTracking.Context.HospitalManager.login(hospital_manager.email, @password)

      %{token: token, hospital_manager: hospital_manager, hospital: hospital}
    end

    @query """
    query getReport {
      getReport {
        report {
          totalBedsOfNonSurgeWards
          totalBedsOfSurgeWards
          totalNonAvailableBedsWhereCovidStatusGreenOrNegativeAndVentilationTypeInvasive
          totalNonAvailableBedsWhereCovidStatusGreenOrNegativeAndVentilationTypeNonInvasive
          totalNonAvailableBedsWhereDateAdmittedYesterday
          totalDischargesWhereReasonNotDeathAndInsertedAtYesterday
          totalDischargesWhereReasonDeathAndInsertedAtYesterday
          totalNonAvailableBedsWhereCovidStatusPositiveOrSuspectedAndRrtTypeHaemodialysis
        }
      }
    }
    """

    test "get report", %{token: token} do
      response =
        graphql_query(query: @query, token: token)
        |> BedTrackingWeb.Endpoint.call([])
        |> Map.get(:resp_body)
        |> Jason.decode!()

      assert %{
               "totalBedsOfNonSurgeWards" => 3,
               "totalBedsOfSurgeWards" => 6,
               "totalNonAvailableBedsWhereCovidStatusGreenOrNegativeAndVentilationTypeInvasive" => 2,
               "totalNonAvailableBedsWhereCovidStatusGreenOrNegativeAndVentilationTypeNonInvasive" => 2,
               "totalNonAvailableBedsWhereDateAdmittedYesterday" => 4,
               "totalDischargesWhereReasonNotDeathAndInsertedAtYesterday" => 1,
               "totalDischargesWhereReasonDeathAndInsertedAtYesterday" => 1,
               "totalNonAvailableBedsWhereCovidStatusPositiveOrSuspectedAndRrtTypeHaemodialysis" => 2
             } = response["data"]["getReport"]["report"]
    end
  end
end
