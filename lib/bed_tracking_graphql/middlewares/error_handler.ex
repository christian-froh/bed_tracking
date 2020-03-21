defmodule BedTrackingGraphql.Middlewares.ErrorHandler do
  require ExErrors
  require Logger
  @behaviour Absinthe.Middleware
  alias BedTracking.Error

  def call(resolution, _config) do
    errors =
      resolution
      |> Map.get(:errors)
      |> Enum.map(&process_error/1)
      |> List.flatten()

    %{resolution | errors: errors}
  end

  defp process_error(ExErrors.error() = error) do
    error = replace_graphql_keys(error)
    error
  end

  defp process_error(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(
      changeset,
      fn
        _changeset, field, {reason, [validation: validation_error]} ->
          validation_error = %Error.ValidationError{
            reason: reason,
            details: to_string(validation_error),
            field: to_string(field)
          }

          validation_error = replace_graphql_keys(validation_error)
          save_error(validation_error)

          # traverse_errors expects to return a string
          ""
      end
    )

    Process.get(:changeset_errors)
  end

  defp process_error(error) do
    # {_, stacktrace} = Process.info(self(), :current_stacktrace)
    error = %Error.UnhandledError{unhandled_error: error}
    error = replace_graphql_keys(error)

    Logger.warn("Unhandled Error: #{inspect(error.unhandledError)}")

    # Sentry.capture_message("Unhandled Error: #{inspect(error.unhandledError)}",
    #   extra: %{error: inspect(error, pretty: true)},
    #   stacktrace: stacktrace
    # )

    error
  end

  defp replace_graphql_keys(error) do
    error =
      Enum.reduce(error, %{}, fn {k, v}, acc ->
        k = Atom.to_string(k) |> Macro.camelize() |> lcfirst() |> String.to_atom()
        Map.put(acc, k, v)
      end)

    error
  end

  defp lcfirst(str) do
    first = String.slice(str, 0..0) |> String.downcase()
    first <> String.slice(str, 1..-1)
  end

  defp save_error(error) do
    errors = Process.get(:changeset_errors, [])
    Process.put(:changeset_errors, [error | errors])
  end
end
