defmodule Moc.Utils.Rarity do
  @rarityScale [
    # Gold
    %{rarity: 1, name: "Ultra Rare", class_name: "rarity-ultra-rare"},
    # Orange
    %{rarity: 5, name: "Very Rare", class_name: "rarity-very-rare"},
    # Yellow
    %{rarity: 10, name: "Rare", class_name: "rarity-rare"},
    # Grey
    %{rarity: 20, name: "Uncommon", class_name: "rarity-uncommon"},
    # White
    %{rarity: 40, name: "Common", class_name: "rarity-common"},
    # Green
    %{rarity: 60, name: "Frequent", class_name: "rarity-frequent"},
    # Blue
    %{rarity: 80, name: "Very Frequent", class_name: "rarity-very-frequent"},
    # SaddleBrown
    %{rarity: 100, name: "Universal", class_name: "rarity-universal"}
  ]

  def get_rarity(percentage) do
    @rarityScale |> Enum.find(fn r -> r.rarity >= percentage end)
  end
end
