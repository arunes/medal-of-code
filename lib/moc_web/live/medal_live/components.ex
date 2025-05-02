defmodule MocWeb.MedalLive.Components do
  use MocWeb, :html

  attr :size, :integer, required: true
  attr :name, :string, required: true
  attr :id, :string, required: true
  attr :affinity, :string, required: true
  attr :class, :string, default: nil

  def medal(assigns) do
    assigns = assign(assigns, :colors, get_medal_colors(assigns.affinity))

    ~H"""
    <div
      class="bg-top bg-no-repeat pt-10 px-4 pb-1 mt-3 medal"
      style={"background-image: url('/images/medal-holder-#{@affinity}.png')"}
    >
      <moc-medal
        id={@id}
        class="rounded-full mx-auto mb-2"
        name={@name}
        size={@size}
        colors-1={@colors.shape_1_color}
        colors-2={@colors.shape_2_color}
        colors-3={@colors.shape_3_color}
        colors-bg={@colors.background}
        phx-update="ignore"
      />
    </div>
    """
  end

  attr :medal, :any, required: true
  attr :show_medal_count, :boolean, required: true

  def medal_box(assigns) do
    ~H"""
    <.link class="box-link" navigate={~p"/medals/#{@medal.id}"} id={"medal-box-#{@medal.id}"}>
      <span :if={@show_medal_count && @medal.total > 0} class="absolute inline-flex top-1 end-2">
        x{@medal.total}
      </span>
      <span class={["absolute inline-flex flex-col top-2 start-3 text-sm", @medal.rarity.className]}>
        {@medal.rarity.name}
      </span>
      <.medal id={"medal-#{@medal.id}"} name={@medal.name} size={82} affinity={@medal.affinity} />
      <p class="text-center">
        {@medal.name}
        <span :if={@medal.is_new} title="NEW">🎉</span>
      </p>
      <p class={["text-center text-sm font-light", @medal.rarity_percentage && "mb-2"]}>
        {@medal.description}
      </p>
      <p
        :if={@medal.rarity_percentage != nil}
        class="text-center text-xs border-t border-dashed pt-2 mt-auto border-moc-3 text-moc-2"
      >
        {@medal.rarity_percentage |> Float.round(2)}% of contributors have this medal.
      </p>
    </.link>
    """
  end

  defp get_medal_colors(:dark) do
    %{
      shape_1_color: "ab2b16",
      shape_2_color: "800000",
      shape_3_color: "2e000b",
      background: "000000"
    }
  end

  defp get_medal_colors(:light) do
    %{
      shape_1_color: "26bdc0",
      shape_2_color: "0d839d",
      shape_3_color: "154b79",
      background: "ffffff"
    }
  end

  defp get_medal_colors(:neutral) do
    %{
      shape_1_color: "787878",
      shape_2_color: "646464",
      shape_3_color: "414141",
      background: "cccccc"
    }
  end
end
