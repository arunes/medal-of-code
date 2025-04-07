defmodule Moc.Utils.Date do
  @moduledoc """
  A utility module for working with dates and times in the Medal of Code project.

  This module provides functions for generating the current UTC date and time,
  converting strings to UTC dates, and formatting UTC dates as strings.
  """

  def utc_now(), do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

  def string_to_utc(str),
    do: str |> NaiveDateTime.from_iso8601() |> elem(1) |> NaiveDateTime.truncate(:second)

  def format_utc_date(date, format \\ "%Y-%m-%dT%H:%M:%SZ"), do: Calendar.strftime(date, format)
end
