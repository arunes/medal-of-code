defmodule MocWeb.Components do
  use Phoenix.Component
  import Moc.Utils.Colors, only: [get_medal_colors: 1]
  alias Phoenix.LiveView.JS

  def contributor_box(assigns) do
    ~H"""
    <a href={"/contributors/#{@contributor.id}"} class="box-link">
      <div class="relative flex items-center gap-x-6">
        <.avatar size="56" alt={@contributor.name} class_name="size-10 md:size-14" />
        <div>
          <h3 class="text-base font-semibold leading-7 tracking-tight">
            {@contributor.name}
            <%= if @settings.contributors.levels do %>
              <span class="ml-2 font-light text-xs">lvl {@contributor.level}</span>
            <% end %>
          </h3>
          <p class="text-sm text-moc-2">
            {@contributor.prefix} {@contributor.title}

            <%= if @settings.contributors.medalCounts || @current_contributor_id == @contributor.id do %>
              <span class="block md:inline">
                🎖️{@contributor.number_of_medals}
              </span>
            <% end %>
          </p>
        </div>

        <%= if @settings.contributors.ranks do %>
          <span class="flex absolute size-8 md:size-10 items-center justify-center bottom-0 right-0 md:top md:bottom-auto rounded-full p-1 bg-moc-2">
            {@contributor.rank}
            <sup class="font-light">{MocWeb.ViewHelpers.get_ordinal(@contributor.rank)}</sup>
          </span>
        <% end %>
      </div>
    </a>
    """
  end

  def avatar(assigns) do
    ~H"""
    <img
      src="/images/avatar-placeholder.png"
      class={"rounded-full #{@class_name}"}
      width={@size}
      height={@size}
      alt={@alt}
      phx-mounted={JS.dispatch("moc:set_avatar")}
    />
    """
  end

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
