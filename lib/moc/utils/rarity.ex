defmodule Moc.Utils.Rarity do
  @rarityScale [
    # Gold
    %{rarity: 1, name: "Ultra Rare", className: "rarity-ultra-rare"},
    # Orange
    %{rarity: 5, name: "Very Rare", className: "rarity-very-rare"},
    # Yellow
    %{rarity: 10, name: "Rare", className: "rarity-rare"},
    # Grey
    %{rarity: 20, name: "Uncommon", className: "rarity-uncommon"},
    # White
    %{rarity: 40, name: "Common", className: "rarity-common"},
    # Green
    %{rarity: 60, name: "Frequent", className: "rarity-frequent"},
    # Blue
    %{rarity: 80, name: "Very Frequent", className: "rarity-very-frequent"},
    # SaddleBrown
    %{rarity: 100, name: "Universal", className: "rarity-universal"}
  ]

  def get_rarity(percentage) do
    @rarityScale |> Enum.find(fn r -> r.rarity >= percentage end)
  end
end
