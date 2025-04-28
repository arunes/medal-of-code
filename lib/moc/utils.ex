defmodule Moc.Utils do
  alias Timex.Duration
  def utc_now(), do: DateTime.utc_now() |> DateTime.truncate(:second)

  def string_to_utc(str),
    do: str |> DateTime.from_iso8601() |> elem(1) |> DateTime.truncate(:second)

  def nullable_atom(nil), do: nil
  def nullable_atom(value), do: value |> String.to_atom()

  def capitalize_first(<<>>), do: ""
  def capitalize_first(<<c::utf8, rest::binary>>), do: String.upcase(<<c>>) <> rest

  def flatten(input, result \\ [])
  def flatten(input, result) when is_list(input), do: Enum.flat_map(input, &flatten(&1, result))
  def flatten(input, result), do: [input | result]

  def get_setting_value(settings, key) do
    case settings |> Enum.find(fn st -> st.key == key end) do
      nil -> false
      s -> s.value == "true"
    end
  end

  def get_duration(0), do: ""

  def get_duration(days, max_parts \\ 3) do
    duration = Duration.from_days(days)
    microseconds = duration |> Duration.to_clock() |> elem(3) |> Duration.from_microseconds()

    duration
    |> Duration.sub(microseconds)
    |> Timex.Format.Duration.Formatters.Humanized.format()
    |> String.split(",", trim: true)
    |> Enum.take(max_parts)
    |> Enum.join(", ")
  end
end
