defmodule MocWeb.ContributorLive.Components do
  alias Moc.Utils
  use MocWeb, :html
  import MocWeb.CustomComponents, only: [avatar: 1]
  alias Moc.Contributors.ContributorOverview

  attr :contributor, ContributorOverview, required: true
  attr :id, :string, required: true
  attr :show_level, :boolean, required: true
  attr :show_rank, :boolean, required: true
  attr :show_medal_count, :boolean, required: true

  def contributor_box(assigns) do
    ~H"""
    <.link class="box-link" navigate={~p"/contributors/#{@contributor.id}"} id={@id}>
      <div class="relative flex items-center gap-x-6">
        <.avatar id={@contributor.id} class="size-10 md:size-14" name={@contributor.name} size={56} />
        <div>
          <h3 class="text-base font-semibold leading-7 tracking-tight">
            {@contributor.name}
            <span :if={@show_level} class="ml-2 font-light text-xs">lvl {@contributor.level}</span>
          </h3>
          <p class="text-sm text-moc-2">
            {@contributor.prefix} {@contributor.title}
            <span :if={@show_medal_count} class="block md:inline">
              🎖️{@contributor.number_of_medals}
            </span>
          </p>
        </div>
        <span
          :if={@show_rank}
          class="flex absolute size-8 md:size-10 items-center justify-center bottom-0 right-0 md:top md:bottom-auto rounded-full p-1 bg-moc-2"
        >
          {@contributor.rank}
          <sup class="font-light">{Utils.get_ordinal(@contributor.rank)}</sup>
        </span>
      </div>
    </.link>
    """
  end
end
