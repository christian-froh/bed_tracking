defmodule BedTrackingGraphql.Schema.Report do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :report do
    field :total_beds_of_non_surge_wards, :integer do
      resolve(fn report, params, info -> Resolver.Report.dataloader_total_beds_of_non_surge_wards(report, params, info, false) end)
    end

    field :total_beds_of_surge_wards, :integer do
      resolve(fn report, params, info -> Resolver.Report.dataloader_total_beds_of_non_surge_wards(report, params, info, true) end)
    end

    field :total_critcare_nurses_of_wards, :integer do
      resolve(&Resolver.Report.dataloader_total_critcare_nurses_of_wards/3)
    end

    field :total_other_rns_of_wards, :integer do
      resolve(&Resolver.Report.dataloader_total_other_rns_of_wards/3)
    end

    field :total_nurse_support_staff_of_wards, :integer do
      resolve(&Resolver.Report.dataloader_total_nurse_support_staff_of_wards/3)
    end

    field :all_wards_can_provide_ics_ratios, :boolean do
      resolve(&Resolver.Report.dataloader_all_wards_can_provide_ics_ratios/3)
    end

    field :total_non_available_beds, :integer do
      resolve(&Resolver.Report.dataloader_total_non_available_beds/3)
    end

    field :total_non_available_beds_where_covid_status_positive, :integer do
      resolve(fn report, params, info -> Resolver.Report.dataloader_total_non_available_beds_where_covid_status(report, params, info, "positive") end)
    end

    field :total_non_available_beds_where_covid_status_unknown_suspected, :integer do
      resolve(fn report, params, info -> Resolver.Report.dataloader_total_non_available_beds_where_covid_status(report, params, info, "unknown_suspected") end)
    end

    field :total_non_available_beds_where_covid_status_green_or_negative_and_ventilation_type_invasive, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(report, params, info, {"green", "negative", "invasive"})
      end)
    end

    field :total_non_available_beds_where_covid_status_green_or_negative_and_ventilation_type_non_invasive, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(
          report,
          params,
          info,
          {"green", "negative", "cpap", "bipap"}
        )
      end)
    end

    field :total_non_available_beds_where_covid_status_green_or_negative_and_ventilation_type_hfno, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(report, params, info, {"green", "negative", "hfno"})
      end)
    end

    field :total_non_available_beds_where_covid_status_green_or_negative_and_rrt_type_haemofiltration, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_rrt_type(report, params, info, {"green", "negative", "haemofiltration"})
      end)
    end

    field :total_non_available_beds_where_covid_status_green_or_negative_and_rrt_type_haemodialysis, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_rrt_type(report, params, info, {"green", "negative", "haemodialysis"})
      end)
    end

    field :total_non_available_beds_where_covid_status_green_or_negative_and_rrt_type_pd, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_rrt_type(report, params, info, {"green", "negative", "pd"})
      end)
    end

    field :total_non_available_beds_where_covid_status_positive_or_unknown_suspected_and_ventilation_type_invasive, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(
          report,
          params,
          info,
          {"positive", "unknown_suspected", "invasive"}
        )
      end)
    end

    field :total_non_available_beds_where_covid_status_positive_or_unknown_suspected_and_ventilation_type_non_invasive, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(
          report,
          params,
          info,
          {"positive", "unknown_suspected", "cpap", "bipap"}
        )
      end)
    end

    field :total_non_available_beds_where_covid_status_positive_or_unknown_suspected_and_ventilation_type_hfno, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_ventilation_type(
          report,
          params,
          info,
          {"positive", "unknown_suspected", "hfno"}
        )
      end)
    end

    field :total_non_available_beds_where_covid_status_positive_or_unknown_suspected_and_rrt_type_haemofiltration, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_rrt_type(
          report,
          params,
          info,
          {"positive", "unknown_suspected", "haemofiltration"}
        )
      end)
    end

    field :total_non_available_beds_where_covid_status_positive_or_unknown_suspected_and_rrt_type_haemodialysis, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_rrt_type(
          report,
          params,
          info,
          {"positive", "unknown_suspected", "haemodialysis"}
        )
      end)
    end

    field :total_non_available_beds_where_covid_status_positive_or_unknown_suspected_and_rrt_type_pd, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_covid_status_and_rrt_type(report, params, info, {"positive", "unknown_suspected", "pd"})
      end)
    end

    field :total_non_available_beds_where_date_admitted_yesterday, :integer do
      resolve(&Resolver.Report.dataloader_total_non_available_beds_where_date_admitted_yesterday/3)
    end

    field :total_discharges_where_reason_not_death_and_inserted_at_yesterday, :integer do
      resolve(&Resolver.Report.dataloader_total_discharges_where_reason_not_death_and_inserted_at_yesterday/3)
    end

    field :total_discharges_where_reason_death_and_inserted_at_yesterday, :integer do
      resolve(&Resolver.Report.dataloader_total_discharges_where_reason_death_and_inserted_at_yesterday/3)
    end

    field :total_non_available_beds_where_ward_type_covid_and_level_of_care_level_three, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_level_of_care(report, params, info, {"covid", "level_3"})
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_level_of_care_level_two, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_level_of_care(report, params, info, {"covid", "level_2"})
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_level_of_care_level_three, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_level_of_care(report, params, info, {"green", "level_3"})
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_level_of_care_level_two, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_level_of_care(report, params, info, {"green", "level_2"})
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_level_of_care_level_three, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_level_of_care(report, params, info, {"amber", "level_3"})
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_level_of_care_level_two, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_level_of_care(report, params, info, {"amber", "level_2"})
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_rrt_type_not_none_or_not_risk_of_next_twenty_four_h, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_rrt_type_not_none_or_not_risk_of_next_twenty_four_h(
          report,
          params,
          info,
          "covid"
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_rrt_type_not_none_or_not_risk_of_next_twenty_four_h, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_rrt_type_not_none_or_not_risk_of_next_twenty_four_h(
          report,
          params,
          info,
          "amber"
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_rrt_type_not_none_or_not_risk_of_next_twenty_four_h, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_rrt_type_not_none_or_not_risk_of_next_twenty_four_h(
          report,
          params,
          info,
          "green"
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_rrt_type_risk_of_next_twenty_four_h, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_rrt_type_risk_of_next_twenty_four_h(
          report,
          params,
          info,
          "covid"
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_rrt_type_risk_of_next_twenty_four_h, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_rrt_type_risk_of_next_twenty_four_h(
          report,
          params,
          info,
          "amber"
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_rrt_type_risk_of_next_twenty_four_h, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_rrt_type_risk_of_next_twenty_four_h(
          report,
          params,
          info,
          "green"
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_source_of_admission_ed, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"covid", "ed"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_source_of_admission_ed, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"green", "ed"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_source_of_admission_ed, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"amber", "ed"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_source_of_admission_internal_ward, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"covid", "internal_ward"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_source_of_admission_internal_ward, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"green", "internal_ward"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_source_of_admission_internal_ward, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"amber", "internal_ward"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_source_of_admission_internal_itu, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"covid", "internal_itu"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_source_of_admission_internal_itu, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"green", "internal_itu"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_source_of_admission_internal_itu, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"amber", "internal_itu"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_source_of_admission_external_ward, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"covid", "external_ward"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_source_of_admission_external_ward, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"green", "external_ward"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_source_of_admission_external_ward, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"amber", "external_ward"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_source_of_admission_external_itu, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"covid", "external_itu"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_source_of_admission_external_itu, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"green", "external_itu"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_source_of_admission_external_itu, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"amber", "external_itu"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_covid_and_source_of_admission_itu_readmission, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"covid", "itu_readmission"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_green_and_source_of_admission_itu_readmission, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"green", "itu_readmission"}
        )
      end)
    end

    field :total_non_available_beds_where_ward_type_amber_and_source_of_admission_itu_readmission, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_non_available_beds_where_ward_type_and_source_of_admission_where_date_admitted_yesterday(
          report,
          params,
          info,
          {"amber", "itu_readmission"}
        )
      end)
    end

    field :total_discharges_where_reason_not_death_and_ward_type_covid_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_not_death_and_ward_type_inserted_at_yesterday(report, params, info, "covid")
      end)
    end

    field :total_discharges_where_reason_not_death_and_ward_type_amber_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_not_death_and_ward_type_inserted_at_yesterday(report, params, info, "amber")
      end)
    end

    field :total_discharges_where_reason_not_death_and_ward_type_green_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_not_death_and_ward_type_inserted_at_yesterday(report, params, info, "green")
      end)
    end

    field :total_discharges_where_reason_death_and_ward_type_covid_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_and_ward_type_inserted_at_yesterday(report, params, info, {"death", "covid"})
      end)
    end

    field :total_discharges_where_reason_death_and_ward_type_amber_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_and_ward_type_inserted_at_yesterday(report, params, info, {"death", "amber"})
      end)
    end

    field :total_discharges_where_reason_death_and_ward_type_green_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_and_ward_type_inserted_at_yesterday(report, params, info, {"death", "green"})
      end)
    end

    field :total_discharges_where_reason_external_icu_and_ward_type_covid_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_and_ward_type_inserted_at_yesterday(report, params, info, {"external_icu", "covid"})
      end)
    end

    field :total_discharges_where_reason_external_icu_and_ward_type_amber_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_and_ward_type_inserted_at_yesterday(report, params, info, {"external_icu", "amber"})
      end)
    end

    field :total_discharges_where_reason_external_icu_and_ward_type_green_and_inserted_at_yesterday, :integer do
      resolve(fn report, params, info ->
        Resolver.Report.dataloader_total_discharges_where_reason_and_ward_type_inserted_at_yesterday(report, params, info, {"external_icu", "green"})
      end)
    end
  end

  ### PAYLOADS ###
  object :get_report_payload do
    field :report, :report
  end

  ### QUERIES ###
  object :report_queries do
    field :get_report, :get_report_payload do
      resolve(&Resolver.Report.get_report/2)
    end
  end
end
