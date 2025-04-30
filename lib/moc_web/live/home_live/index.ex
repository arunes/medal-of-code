defmodule MocWeb.HomeLive.Index do
  use MocWeb, :live_view
  import MocWeb.HistoryListComponent

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="my-12">
        <.logo width={350} />
        <p class="text-center text-lg mt-4 md:px-12">
          Turn your development work into a playful quest for glory with Medal
          of Code — the gamified dev experience!
        </p>
      </div>

      <.title size="xl2">Latest Updates</.title>
      <.history_list number_of_records={10} current_contributor_id={@current_user.contributor_id} />
    </div>
    """
  end
end
