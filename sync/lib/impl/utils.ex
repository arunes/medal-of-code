defmodule Sync.Impl.Utils do
  def new_utc, do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

  def string_to_utc(str),
    do: str |> DateTime.from_iso8601() |> elem(1) |> DateTime.truncate(:second)

  def format_utc_date(date), do: Calendar.strftime(date, "%Y-%m-%dT%H:%M:%SZ")
end
