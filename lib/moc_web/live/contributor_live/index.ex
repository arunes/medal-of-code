defmodule MocWeb.ContributorLive.Index do
  alias Moc.Utils
  use MocWeb, :live_view
  import MocWeb.ContributorLive.Components

  def mount(params, _session, socket) do
    contributors = Moc.Contributors.get_contributor_list(params)
    settings = Moc.Instance.get_settings()
    contributor_id = socket.assigns.current_user.contributor_id

    contributor_settings = %{
      show_level: settings |> Utils.get_setting_value("contributor.show_level"),
      show_rank: settings |> Utils.get_setting_value("contributor.show_rank"),
      show_medal_count: settings |> Utils.get_setting_value("contributor.show_medal_count")
    }

    socket =
      socket
      |> assign(:page_title, "Contributors")
      |> assign(:contributor_id, contributor_id)
      |> assign(:settings, contributor_settings)
      |> assign(:form, to_form(params))
      |> assign(:total_contributors, length(contributors))
      |> stream(:contributors, contributors)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.filter_form form={@form} />
    <.messages total_contributors={@total_contributors} search={@form.params["search"]} />

    <section
      :if={@total_contributors > 0}
      class="grid gap-3 md:grid-cols-2"
      id="contributor_list"
      phx-update="stream"
    >
      <.contributor_box
        :for={{dom_id, contributor} <- @streams.contributors}
        id={dom_id}
        contributor={contributor}
        show_level={@settings.show_level || @contributor_id == contributor.id}
        show_rank={@settings.show_rank}
        show_medal_count={@settings.show_medal_count || @contributor_id == contributor.id}
      />
    </section>
    """
  end

  def handle_event("filter", params, socket) do
    contributors = Moc.Contributors.get_contributor_list(params)

    socket =
      socket
      |> assign(:form, to_form(params))
      |> assign(:total_contributors, length(contributors))
      |> stream(:contributors, contributors, reset: true)

    {:noreply, socket}
  end

  attr :total_contributors, :integer, required: true
  attr :search, :string, required: true

  def messages(assigns) do
    ~H"""
    <p :if={@total_contributors == 0 && @search != ""} class="font-light italic px-4 text-center">
      Alas, the scrolls of code bear no record of noble{" "}
      <strong>&quot;{@search}&quot;</strong>. Perhaps they are a wanderer yet
      to join our quest, or a sage whose tales are still unwritten. Fear
      not, search again, and you may yet uncover their legend.
    </p>

    <p :if={@total_contributors == 0 && @search == ""} class="text-center text-moc-2">
      &quot;The echoes of the hall stand silent, with no tales of the coders
      quests. Mayhaps they are a phantom yet to reveal their codecraft.&quot;
    </p>
    """
  end

  attr :form, :any

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" class="mb-5" phx-change="filter">
      <.input
        type="text"
        field={@form[:search]}
        phx-debounce={500}
        placeholder="Search contributors"
        autocomplete="off"
      />
    </.form>
    """
  end
end
