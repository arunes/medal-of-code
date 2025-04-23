defmodule MocWeb.AdminLive.Organization.Repositories do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(%{"organization_id" => organization_id, "project_id" => project_id}, _session, socket) do
    repositories = Moc.Admin.get_repository_list(organization_id, project_id)

    socket =
      socket
      |> assign(:page_title, "Admin | Repositories")
      |> assign(:total_repositories, length(repositories))
      |> assign(:organization_id, organization_id)
      |> assign(:project_id, project_id)
      |> stream(:repositories, repositories)

    {:ok, socket}
  end

  def handle_event("toggle-sync", %{"repository_id" => repository_id}, socket) do
    Moc.Admin.toggle_sync(repository_id)

    repositories =
      Moc.Admin.get_repository_list(socket.assigns.organization_id, socket.assigns.project_id)

    {:noreply,
     socket
     |> stream(:repositories, repositories)
     |> put_flash(:info, "Sync settings updated successfully!")}
  end

  def render(assigns) do
    ~H"""
    <.admin_content selected_nav="organizations">
      <.table
        :if={@total_repositories > 0}
        id="repositories"
        rows={@streams.repositories}
        row_id={fn {id, _row} -> id end}
        row_item={fn {_id, row} -> row end}
      >
        <:col :let={rp} label="Name">{rp.name}</:col>
        <:col :let={rp} align="center" width="120px" label="Sync Enabled?">
          <button phx-click="toggle-sync" phx-value-repository_id={rp.id}>
            <.icon :if={rp.sync_enabled} name="hero-check" class="h-5 w-5" />
            <.icon :if={not rp.sync_enabled} name="hero-x-mark" class="h-5 w-5" />
          </button>
        </:col>
        <:col :let={rp} align="right" width="220px" label="Import After">
          <.local_datetime date={rp.cutoff_date} />
        </:col>
      </.table>
      <div :if={@total_repositories == 0} colspan="5" class="text-sm">
        No repositories found!, add an organization to start using Medal of Code.
      </div>
    </.admin_content>
    """
  end
end
