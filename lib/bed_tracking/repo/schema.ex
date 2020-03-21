defmodule BedTracking.Repo.Schema do
  defmacro __using__(params) do
    autogenerate =
      case params[:autogenerate_primary_key] do
        nil -> true
        boolean -> boolean
      end

    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: unquote(autogenerate)}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime]
    end
  end
end
