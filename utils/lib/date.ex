defmodule Moc.Utils.Date do
  @moduledoc """
  A utility module for working with dates and times in the Medal of Code project.

  This module provides functions for generating the current UTC date and time,
  converting strings to UTC dates, and formatting UTC dates as strings.
  """

  @doc """
  Returns the current UTC date and time, truncated to the nearest second.

  ## Returns
    A NaiveDateTime struct representing the current UTC date and time.
  """
  def new_utc, do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

  @doc """
  Converts a string in ISO 8601 format to a UTC date and time.

  ## Parameters
    str (String): The string to convert.

  ## Returns
    A DateTime struct representing the converted UTC date and time.

  ## Examples
      iex> Moc.Utils.Date.string_to_utc("2022-01-01T12:00:00Z")
      ~U[2022-01-01 12:00:00Z]
  """
  def string_to_utc(str), do: str |> DateTime.from_iso8601() |> elem(1) |> DateTime.truncate(:second)

  @doc """
  Formats a UTC date and time as a string according to the specified format.

  ## Parameters
    date (DateTime | NaiveDateTime): The date and time to format.
    format (String, optional): The format string. Defaults to "%Y-%m-%dT%H:%M:%SZ".

  ## Returns
    A string representing the formatted UTC date and time.

  ## Examples
      iex> Moc.Utils.Date.format_utc_date(~U[2022-01-01 12:00:00Z])
      "2022-01-01T12:00:00Z"

      iex> Moc.Utils.Date.format_utc_date(~U[2022-01-01 12:00:00Z], "%Y/%m/%d %H:%M")
      "2022/01/01 12:00"
  """
  def format_utc_date(date, format \\ "%Y-%m-%dT%H:%M:%SZ"), do: Calendar.strftime(date, format)
end
