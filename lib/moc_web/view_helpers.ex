defmodule MocWeb.ViewHelpers do
  def get_ordinal(number) when is_integer(number) do
    cond do
      rem(number, 10) == 1 && rem(number, 100) != 11 -> "st"
      rem(number, 10) == 2 && rem(number, 100) != 12 -> "nd"
      rem(number, 10) == 3 && rem(number, 100) != 13 -> "rd"
      true -> "th"
    end
  end
end
