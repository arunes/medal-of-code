defmodule MocWeb.AdminLive.Contributors do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components
  alias Moc.Contributors

  def mount(_params, _session, socket) do
    contributors = Contributors.get_contributor_list()

    socket =
      socket
      |> assign(:page_title, "Admin | Users")
      |> assign(:total_contributors, length(contributors))
      |> stream(:contributors, contributors)

    {:ok, socket}
  end

  def handle_event("toggle-visibility", %{"contributor_id" => contributor_id}, socket) do
    Contributors.toggle_visibility!(contributor_id)

    contributors =
      Contributors.get_contributor_list()

    {:noreply,
     socket
     |> stream(:contributors, contributors)
     |> put_flash(:info, "Visibility settings updated successfully!")}
  end

  def render(assigns) do
    breadcrumb = [%{link: "", label: "Contributors"}]
    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="contributors" breadcrumb={@breadcrumb}>
      <p class="text-sm mb-3">
        Click <.icon name="hero-check" class="h-5 w-5 align-text-top" /> or
        <.icon name="hero-x-mark" class="h-5 w-5 align-text-top" /> icons to set visibility status.
      </p>
      <.table
        :if={@total_contributors > 0}
        id="contributors"
        rows={@streams.contributors}
        row_id={fn {id, _row} -> id end}
        row_item={fn {_id, row} -> row end}
      >
        <:col :let={cnt} label="Name">
          {cnt.name}
        </:col>
        <:col :let={cnt} label="Email">{cnt.email}</:col>
        <:col :let={cnt} align="center" width="120px" label="Visible?">
          <button phx-click="toggle-visibility" phx-value-contributor_id={cnt.id}>
            <.icon :if={cnt.is_visible} name="hero-check" class="h-5 w-5" />
            <.icon :if={not cnt.is_visible} name="hero-x-mark" class="h-5 w-5" />
          </button>
        </:col>

        <:col :let={cnt} align="right" width="120px" label="Create Date">
          <.local_datetime date={cnt.inserted_at} format="date" />
        </:col>
      </.table>
      <div :if={@total_contributors == 0} colspan="5" class="text-sm">
        No repositories found!, make sure current project has at least one repository and you have access to it.
      </div>
    </.admin_content>
    """
  end
end
