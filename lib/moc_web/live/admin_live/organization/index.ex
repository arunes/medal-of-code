defmodule MocWeb.AdminLive.Organization.Index do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(_params, _session, socket) do
    organizations = Moc.Admin.get_organization_list()

    socket =
      socket
      |> assign(:page_title, "Admin | Organizations")
      |> assign(:total_organizations, length(organizations))
      |> stream(:organizations, organizations)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.admin_content selected_nav="organizations">
      <.table
        :if={@total_organizations > 0}
        id="organizations"
        rows={@streams.organizations}
        row_id={fn {id, _row} -> id end}
        row_item={fn {_id, row} -> row end}
        row_click={fn {_id, row} -> JS.navigate(~p"/admin/organizations/#{row}") end}
      >
        <:col :let={org} label="Id">{org.external_id}</:col>
        <:col :let={org} label="Provider">{org.provider}</:col>
        <:col :let={org} align="center" label="Projects">{org.total_projects}</:col>
        <:col :let={org} align="center" label="Repos (In sync/total)">
          {org.total_active_repos} / {org.total_repos}
        </:col>
        <:col :let={org} align="right" label="Last Update">
          <.local_datetime date={org.updated_at} />
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
      <div :if={@total_organizations == 0} colspan="5" class="text-sm">
        No organization found!, add an organization to start using Medal of Code.
      </div>

      <.link navigate={~p"/admin/organizations/new"} class="moc-btn-blue">
        Add Organization
      </.link>
    </.admin_content>
    """
  end
end
