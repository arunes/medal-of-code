defmodule MocWeb.Components.Medal do
  use Phoenix.Component
  import Moc.Utils.Colors, only: [get_medal_colors: 1]
  alias Phoenix.LiveView.JS

  def medal(assigns) do
    assigns = assign(assigns, :colors, get_medal_colors(assigns.affinity))

    ~H"""
    <div
      class="bg-top bg-no-repeat pt-10 px-4 pb-1 mt-3 medal"
      style={"background-image: url('/images/medal-holder-#{@affinity}.png')"}
    >
      <img
        src="images/medal-placeholder.png"
        width={@size}
        height={@size}
        alt={@name}
        data-colors-1={@colors.shape_1_color}
        data-colors-2={@colors.shape_2_color}
        data-colors-3={@colors.shape_3_color}
        data-colors-bg={@colors.background}
        style={"
          border-top: 7px solid ##{@colors.shape_1_color};
          border-left: 7px solid ##{@colors.shape_1_color};
          border-right: 7px solid ##{@colors.shape_2_color};
          border-bottom: 7px solid ##{@colors.shape_2_color};
          box-shadow: 0 0 10px 3px ##{@colors.shape_3_color}
        "}
        class="rounded-full mx-auto mb-2"
        phx-mounted={JS.dispatch("moc:set_medal")}
      />
    </div>
    """
  end
end
