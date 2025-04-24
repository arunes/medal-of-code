defmodule MocWeb.AdminLive.Organization.Repositories do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(%{"organization_id" => organization_id, "project_id" => project_id}, _session, socket) do
    organization = Moc.Admin.get_organization!(organization_id)
    project = Moc.Admin.get_project!(project_id)
    repositories = Moc.Admin.get_repository_list(organization_id, project_id)

    socket =
      socket
      |> assign(:page_title, "Admin | Repositories")
      |> assign(:total_repositories, length(repositories))
      |> assign(:organization, organization)
      |> assign(:project, project)
      |> stream(:repositories, repositories)

    {:ok, socket}
  end

  def handle_event("toggle-sync", %{"repository_id" => repository_id}, socket) do
    Moc.Admin.toggle_sync!(repository_id)

    repositories =
      Moc.Admin.get_repository_list(socket.assigns.organization.id, socket.assigns.project.id)

    {:noreply,
     socket
     |> stream(:repositories, repositories)
     |> put_flash(:info, "Sync settings updated successfully!")}
  end

  def render(assigns) do
    breadcrumb = [
      %{link: ~p"/admin/organizations", label: "Organizations"},
      %{
        link: ~p"/admin/organizations/#{assigns.organization.id}",
        label: assigns.organization.external_id
      },
      %{
        link: "",
        label: assigns.project.name
      }
    ]

    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="organizations" breadcrumb={@breadcrumb}>
      <p class="text-sm mb-3">
        Click <.icon name="hero-check" class="h-5 w-5 align-text-top" /> or
        <.icon name="hero-x-mark" class="h-5 w-5 align-text-top" /> icons to set sync status.
      </p>
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
        No repositories found!, make sure current project has at least one repository and you have access to it.
      </div>
    </.admin_content>
    """
  end
end
