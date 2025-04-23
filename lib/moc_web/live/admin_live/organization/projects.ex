defmodule MocWeb.AdminLive.Organization.Projects do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(%{"organization_id" => organization_id}, _session, socket) do
    projects = Moc.Admin.get_project_list(organization_id)
    organization = Moc.Admin.get_organization!(organization_id)

    socket =
      socket
      |> assign(:page_title, "Admin | Projects")
      |> assign(:total_projects, length(projects))
      |> assign(:organization, organization)
      |> stream(:projects, projects)

    {:ok, socket}
  end

  def render(assigns) do
    breadcrumb = [
      %{link: "/admin/organizations", label: "Organizations"},
      %{link: "", label: assigns.organization.external_id}
    ]

    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="organizations" breadcrumb={@breadcrumb}>
      <.table
        :if={@total_projects > 0}
        id="organizations"
        rows={@streams.projects}
        row_id={fn {id, _row} -> id end}
        row_item={fn {_id, row} -> row end}
        row_click={
          fn {_id, row} -> JS.navigate(~p"/admin/organizations/#{@organization.id}/#{row}") end
        }
      >
        <:col :let={prj} label="Name">{prj.name}</:col>
        <:col :let={prj} label="Description">{prj.description || "N/A"}</:col>
        <:col :let={prj} align="center" label="Repos (In sync/total)">
          {prj.total_active_repos} / {prj.total_repos}
        </:col>
      </.table>
      <div :if={@total_projects == 0} colspan="5" class="text-sm">
        No projects found!, make sure current organization has at least one project and you have access to it.
      </div>
    </.admin_content>
    """
  end
end
