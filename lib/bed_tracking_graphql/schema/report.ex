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

    field :total_non_available_beds_where_covid_status_suspected, :integer do
      resolve(fn report, params, info -> Resolver.Report.dataloader_total_non_available_beds_where_covid_status(report, params, info, "suspected") end)
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
