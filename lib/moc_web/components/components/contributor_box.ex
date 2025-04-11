defmodule MocWeb.Components.ContributorBox do
  use Phoenix.Component
  import MocWeb.Components.Avatar

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
end
