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

  def handle_event("delete", %{"organization_id" => organization_id}, socket) do
    Moc.Admin.delete_organization!(organization_id)
    organizations = Moc.Admin.get_organization_list()

    socket =
      socket
      |> assign(:page_title, "Admin | Organizations")
      |> assign(:total_organizations, length(organizations))
      |> stream(:organizations, organizations)

    {:noreply, socket}
  end

  def render(assigns) do
    breadcrumb = [%{link: "", label: "Organizations"}]
    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="organizations" breadcrumb={@breadcrumb}>
      <.delete_modal :for={{_, org} <- @streams.organizations} org={org} />

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
        <:action :let={org}>
          <div class="inline-flex" role="group">
            <button
              type="button"
              class="p-2"
              title="Delete"
              phx-click={show_modal("delete-modal-#{org.id}")}
            >
              <.icon name="hero-trash" class="h-4 w-4" />
            </button>
          </div>
        </:action>
      </.table>
      <div :if={@total_organizations == 0} class="text-sm">
        No organization found!, add an organization to start using Medal of Code.
      </div>

      <div class="mt-5">
        <.link navigate={~p"/admin/organizations/new"} class="moc-btn-blue">
          Add Organization
        </.link>
      </div>
    </.admin_content>
    """
  end

  def delete_modal(assigns) do
    ~H"""
    <.modal id={"delete-modal-#{@org.id}"} size="md">
      Are you sure want to delete the <strong>{@org.external_id}</strong>
      organization and all the records associated with? <hr class="my-4" />
      <.button
        show_icon={false}
        variation={:red}
        phx-click="delete"
        phx-value-organization_id={@org.id}
      >
        Delete
      </.button>
      <.button show_icon={false} variation={:gray} phx-click={hide_modal("delete-modal-#{@org.id}")}>
        Cancel
      </.button>
    </.modal>
    """
  end
end
