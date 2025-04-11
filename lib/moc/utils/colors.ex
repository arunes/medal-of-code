defmodule Moc.Utils.Colors do
  def get_medal_colors("dark") do
    %{
      shape_1_color: "ab2b16",
      shape_2_color: "800000",
      shape_3_color: "2e000b",
      background: "000000"
    }
  end

  def get_medal_colors("light") do
    %{
      shape_1_color: "26bdc0",
      shape_2_color: "0d839d",
      shape_3_color: "154b79",
      background: "ffffff"
    }
  end

  def get_medal_colors("neutral") do
    %{
      shape_1_color: "787878",
      shape_2_color: "646464",
      shape_3_color: "414141",
      background: "cccccc"
    }
  end
end
