defmodule BedTracking.Factory.HospitalManager do
  defmacro __using__(_opts) do
    quote do
      def hospital_manager_factory do
        hospital = build(:hospital)

        %BedTracking.Repo.HospitalManager{
          email: sequence(:email, &"hospital_manager-#{&1}@hospital.com"),
          firstname: "Christian",
          lastname: "Froh",
          phone_number: "+491748556633",
          last_login_at: DateTime.utc_now(),
          # 123123123
          password_hash: "$2b$12$kgEGbWoo1pJFrmY5ssvdgePt8YY2gKwj.2N7tmCNOWcieY7gFHT.O",
          hospital: hospital
        }
      end
    end
  end
end
