defmodule MocWeb.ContributorLive do
  use MocWeb, :live_view
  import Ecto.Query
  import MocWeb.Components
  alias Moc.Repo
  alias Moc.Schema.ContributorOverview
  alias Moc.Settings

  def mount(_params, _session, socket) do
    contributors = query_get_contributors() |> Repo.all()

    socket =
      assign(
        socket,
        query: "",
        contributors: contributors,
        settings: Settings.get(),
        current_contributor_id: 1
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="grid gap-3 md:grid-cols-2">
      <!--
      <div class="md:col-span-2">
        <input
          type="text"
          class="bg-moc-1 border text-sm rounded-lg block w-full p-2.5 border-transparent !outline-none"
          placeholder="Search contributors"
          phx-keyup="search"
          phx-debounce="500"
        />
      </div>
      -->

      <%= if length(@contributors) == 0 do %>
        <p class="col-span-2 font-light italic px-4 text-center">
          Alas, the scrolls of code bear no record of noble{" "}
          <strong>&quot;{@query}&quot;</strong>. Perhaps they are a wanderer yet
          to join our quest, or a sage whose tales are still unwritten. Fear
          not, search again, and you may yet uncover their legend.
        </p>
      <% else %>
        <%= for contributor <- @contributors do %>
          <.contributor_box
            contributor={contributor}
            settings={@settings}
            current_contributor_id={@current_contributor_id}
          />
        <% end %>
      <% end %>
    </section>
    """
  end

  def handle_event("search", %{"value" => query}, socket) do
    contributors = query_get_contributors(query) |> Repo.all()
    socket = assign(socket, query: query, contributors: contributors)
    {:noreply, socket}
  end

  # Queries
  defp query_get_contributors(query \\ "") do
    settings = Settings.get()
    settings |> IO.inspect()

    from(cnt in ContributorOverview,
      where: ^query == "" or like(cnt.name, ^"%#{query}%"),
      select: %{
        id: cnt.id,
        name: cnt.name,
        rank: cnt.rank,
        level: cnt.level,
        title: cnt.title,
        prefix: cnt.prefix,
        number_of_medals: cnt.number_of_medals
      }
    )
    |> sort_contributors(settings.contributors.ranks |> IO.inspect())
  end

  defp sort_contributors(query, true), do: query |> order_by([c], asc: c.rank)
  defp sort_contributors(query, false), do: query |> order_by([c], asc: c.name)
end
