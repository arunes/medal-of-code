defmodule Moc.Utils do
  alias Timex.Duration

  @tag_lines [
    "All hail the {title}, with {medals} medals to their code-slinging name! 🚀",
    "Feast your eyes on the {medals}-medal {title}! Their bug-squashing saga continues… 🐛",
    "Witness the rise of the {medals}-medal {title}! Protector of pixels and slayer of syntax errors! 🛡️",
    "Cheers to the {medals}-medal {title}! May your loops never be infinite and your code ever clean! ✨",
    "Stand back for the {medals}-medal {title}! Transmuting coffee into code since who knows! ☕",
    "Give it up for the {medals}-medal {title}! Keeping the code frontier safe from bugs! 🤠",
    "Marvel at the {medals}-medal {title}! No error too big, no bug too small! 🕵️‍♂️",
    "Salute the {medals}-medal {title}! On a quest to refactor the realm one commit at a time! 🗡️",
    "Bow down to the {medals}-medal {title}! With spells to make even the trickiest code behave! 🌿",
    "A round of applause for the {medals}-medal {title}! Master of merges, keeper of branches! 🌳",
    "Behold the {medals}-medal {title}! Composer of code and maestro of methods! 🎼",
    "Spotlight on the {medals}-medal {title}! Their code runs circles around the rest! 🔄",
    "Cheer for the {medals}-medal {title}! Weaving tales of code in zeroes and ones! 🎭",
    "Kudos to the {medals}-medal {title}! Guardian of graphics and savior of sprites! 🎨",
    "Hats off to the {medals}-medal {title}! Leading the charge in data storage battles! 💾",
    "Presenting the {medals}-medal {title}! Where design meets code in a magical fusion! ✨",
    "Applaud the {medals}-medal {title}! Crafting the backbone of code with finesse! 🛠️",
    "Celebrate the {medals}-medal {title}! Expanding horizons with every extension! 🌐",
    "Honor the {medals}-medal {title}! Summoning sublime scripts with a flick of the keys! 🧙‍♂️",
    "Recognize the {medals}-medal {title}! Their wisdom in code is beyond compare! 📜",
    "Laud the {medals}-medal {title}! Painting logic with the brush of brilliance! 🎨",
    "Admire the {medals}-medal {title}! Champion of databases, defender of data integrity! 🛡️",
    "Praise the {medals}-medal {title}! Turning code catastrophes into smooth sailing! 🌊",
    "Revere the {medals}-medal {title}! Wielding git commands like ancient spells! 🪄",
    "Acclaim the {medals}-medal {title}! Peering into arrays and foreseeing function futures! 🔮",
    "Hail the {medals}-medal {title}! Conjuring up solutions from the depths of documentation! 📚",
    "Applaud the {medals}-medal {title}! Master of patterns, seeker of strings! 🎭",
    "Cheer for the {medals}-medal {title}! Mapping out software architectures with ease! 🗺️",
    "Salute the {medals}-medal {title}! Sailing through seas of syntax, plundering pesky problems! ⚓",
    "Celebrate the {medals}-medal {title}! Harmonizing code conflicts with a touch of tranquility! ☮️"
  ]

  @rarity_scale [
    %{rarity: 1, name: "Ultra Rare", class_name: "rarity-ultra-rare"},
    %{rarity: 5, name: "Very Rare", class_name: "rarity-very-rare"},
    %{rarity: 10, name: "Rare", class_name: "rarity-rare"},
    %{rarity: 20, name: "Uncommon", class_name: "rarity-uncommon"},
    %{rarity: 40, name: "Common", class_name: "rarity-common"},
    %{rarity: 60, name: "Frequent", class_name: "rarity-frequent"},
    %{rarity: 80, name: "Very Frequent", class_name: "rarity-very-frequent"},
    %{rarity: 100, name: "Universal", class_name: "rarity-universal"}
  ]

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

  def get_duration(days, max_parts \\ 3)
  def get_duration(days, _) when days <= 0, do: "N/A"

  def get_duration(days, max_parts) do
    duration = Duration.from_days(days)
    microseconds = duration |> Duration.to_clock() |> elem(3) |> Duration.from_microseconds()

    duration
    |> Duration.sub(microseconds)
    |> Timex.Format.Duration.Formatters.Humanized.format()
    |> String.split(",", trim: true)
    |> Enum.take(max_parts)
    |> Enum.join(", ")
  end

  def get_ordinal(number) do
    cond do
      rem(number, 10) == 1 && rem(number, 100) != 11 -> "st"
      rem(number, 10) == 2 && rem(number, 100) != 12 -> "nd"
      rem(number, 10) == 3 && rem(number, 100) != 13 -> "rd"
      true -> "th"
    end
  end

  def get_tag_line(prefix, title, medal_count, level) do
    seed = "#{prefix}#{title}#{medal_count}#{level}" |> String.to_charlist() |> Enum.sum()
    full_title = [prefix, title] |> Enum.filter(fn p -> p != "" end) |> Enum.join(" ")

    pick_tag_line(medal_count, seed)
    |> String.replace("{medals}", medal_count |> to_string())
    |> String.replace("{title}", full_title)
  end

  def pick_tag_line(0, _), do: "Every coder's journey begins with a single commit. 🏁"

  def pick_tag_line(_, seed) do
    seed |> rem(length(@tag_lines)) |> then(&Enum.at(@tag_lines, &1))
  end

  def get_rarity(percentage), do: @rarity_scale |> Enum.find(&(&1.rarity >= percentage))
end
