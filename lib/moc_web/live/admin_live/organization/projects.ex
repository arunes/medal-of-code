defmodule MocWeb.AdminLive.Organization.Projects do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(%{"organization_id" => organization_id}, _session, socket) do
    projects = Moc.Admin.get_project_list(organization_id)

    socket =
      socket
      |> assign(:page_title, "Admin | Projects")
      |> assign(:total_projects, length(projects))
      |> assign(:organization_id, organization_id)
      |> stream(:projects, projects)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.admin_content selected_nav="organizations">
      <.table
        :if={@total_projects > 0}
        id="organizations"
        rows={@streams.projects}
        row_id={fn {id, _row} -> id end}
        row_item={fn {_id, row} -> row end}
        row_click={
          fn {_id, row} -> JS.navigate(~p"/admin/organizations/#{@organization_id}/#{row}") end
        }
      >
        <:col :let={prj} label="Name">{prj.name}</:col>
        <:col :let={prj} label="Description">{prj.description || "N/A"}</:col>
        <:col :let={prj} align="center" label="Repos (In sync/total)">
          {prj.total_active_repos} / {prj.total_repos}
        </:col>
        <:action>
          <div class="inline-flex" role="group">
            <button type="button" title="Sync Organization">
              <.icon name="hero-arrow-path" class="h-4 w-4" />
            </button>
            <button type="button" class="p-2" title="Delete">
              <.icon name="hero-trash" class="h-4 w-4" />
            </button>
          </div>
        </:action>
      </.table>
      <div :if={@total_projects == 0} colspan="5" class="text-sm">
        No projects found!, add an organization to start using Medal of Code.
      </div>
    </.admin_content>
    """
  end
end
