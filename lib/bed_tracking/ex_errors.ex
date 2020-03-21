defmodule ExErrors do
  @moduledoc """
  Contains helper functions for determining if a given error is defined by the given error
  definition.

  Also defines a macro to help define `ExError`-type error structs. See `README.md` for more
  details and usage instructions
  """

  import Kernel, except: [self: 0]

  @opaque t :: %{__struct__: term(), error_code: term(), message: term()}

  defmacro __using__(_opts) do
    quote do
      @opaque t :: %{__struct__: __MODULE__, error_code: term(), message: term()}

      # We need to keep track of whether or not a given error was defined by
      # `:ex_error` for `ExErrors.list_errors/1` and
      # `ExErrors.list_error_specs/1` to work correctly.
      Module.put_attribute(__MODULE__, :ex_error, true)
      Module.register_attribute(__MODULE__, :ex_error, persist: true)

      # We need to keep track of what keys, if any, are enforced for a
      # particular struct definition for `__MODULE__.spec/0` and
      # `ExErrors.list_error_specs/1` to work correctly.
      Module.register_attribute(__MODULE__, :enforce_keys, persist: true)

      def error_code(), do: Map.get(struct(__MODULE__, []), :error_code)

      def spec() do
        enforced_keys =
          __MODULE__.__info__(:attributes)
          |> Keyword.get(:enforce_keys, [])

        all_keys = (struct(__MODULE__, []) |> Map.keys()) -- [:__struct__]

        %{error_code: error_code(), fields: all_keys, required_fields: enforced_keys}
      end

      defimpl Enumerable, for: __MODULE__ do
        def count(enumerable), do: enumerable |> Map.from_struct() |> Enumerable.count()

        def member?(enumerable, element),
          do: enumerable |> Map.from_struct() |> Enumerable.member?(element)

        def reduce(enumerable, acc, fun),
          do: enumerable |> Map.from_struct() |> Enumerable.reduce(acc, fun)

        def slice(enumerable), do: enumerable |> Map.from_struct() |> Enumerable.slice()
      end
    end
  end

  @doc """
  For pattern matching against an ExErrors implemented error
  i.e. ```
  require ExErrors

  def handle_error(ExErrors.error() = error), do: {:error, error}
  def handle_error(error), do: {:error, %MyProject.Errors.UnhandledError{error: error}}
  ```
  """
  defmacro error() do
    quote do
      %{__struct__: _, error_code: _, message: _}
    end
  end

  @doc """
  For pattern matching against an ExErrors implemented error that is of the type defined by the given definition
  i.e. ```
  require ExErrors

  def handle_error(ExErrors.error(MyProject.Errors.BenignError) = error), do: {:error, error}
  def handle_error(error), do: {:error, %MyProject.Errors.UnhandledError{error: error}}
  ```
  """
  defmacro error(definition) do
    quote do
      %{__struct__: unquote(definition), error_code: _, message: _}
    end
  end

  @doc """
  For a given `application`, lists all modules which `use ExErrors`
  """
  @spec list_errors(application :: atom()) :: [ExErrors.t()]
  def list_errors(application) do
    with {:ok, modules} when is_list(modules) <- :application.get_key(application, :modules) do
      modules
      |> Enum.filter(fn module ->
        module.__info__(:attributes)
        |> Enum.any?(fn {key, value} -> key == :ex_error and value == [true] end)
      end)
    else
      :undefined -> []
    end
  end

  @doc """
  For a given `application`, lists all error specs defined in modules which `use ExErrors`
  """
  @spec list_error_specs(application :: atom()) :: [
          %{error_code: term(), fields: [atom()], required_fields: [atom()]}
        ]
  def list_error_specs(application) do
    list_errors(application)
    |> Enum.map(& &1.spec)
  end

  @doc """
  When given some map which contains errors, determins if any member of those errors is an error defined by
  `definition` which is a module which `defstruct`s the given error and also `use`es `ExErrors`
  """
  @spec has_error(errors :: term, definition :: module(), fields :: list) :: boolean
  def has_error(errors, definition, fields \\ [])

  def has_error(%{"errors" => errors}, definition, fields) when is_list(errors),
    do: Enum.any?(errors, &is_error(&1, definition, fields))

  def has_error(%{errors: errors}, definition, fields) when is_list(errors),
    do: Enum.any?(errors, &is_error(&1, definition, fields))

  def has_error(errors, definition, fields) when is_list(errors),
    do: Enum.any?(errors, &is_error(&1, definition, fields))

  def has_error(_errors, _definition, _fields), do: false

  @doc """
  When given an error struct, or stringified error struct, determines if said error struct was defined by `definition`
  which is a module which `defstruct`s the given error and also `use`es `ExErrors`
  """
  @spec is_error(error :: ExErrors.t() | term, definition :: module(), fields :: list) :: boolean
  def is_error(error, definition, fields \\ [])

  def is_error(%{"error_code" => error_code} = error, definition, fields),
    do: check_error_type(error_code, definition) and check_fields(error, fields)

  def is_error(%{error_code: error_code} = error, definition, fields),
    do: check_error_type(error_code, definition) and check_fields(error, fields)

  def is_error(_error, _definition, _fields), do: false

  # Ensures that the given error_type is returned by defintiion.error_code/0
  defp check_error_type(error_type, definition) do
    with {:module, ^definition} <- Code.ensure_loaded(definition),
         true <- Kernel.function_exported?(definition, :error_code, 0) do
      error_type == definition.error_code()
    else
      _ -> false
    end
  end

  # Ensures that the given fields are a subset of the fields in `error`
  defp check_fields(error, fields) do
    MapSet.subset?(to_normalized_mapset(fields), to_normalized_mapset(error))
  end

  defp to_normalized_mapset(%_{} = enumerable),
    do: enumerable |> Map.from_struct() |> to_normalized_mapset

  defp to_normalized_mapset(enumerable),
    do: enumerable |> Enum.map(fn {k, v} -> {to_string(k), v} end) |> MapSet.new()
end
