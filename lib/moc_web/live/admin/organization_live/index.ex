defmodule MocWeb.Admin.OrganizationLive.Index do
  use MocWeb, :live_view
  import MocWeb.Components.AdminNav

  def mount(_params, _session, socket) do
    organizations = Moc.Admin.get_organization_list()
    socket = assign(socket, organizations: organizations)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.admin_nav selected="organizations" />
    <div class="relative overflow-x-auto">
      <table class="w-full text-left mb-12">
        <thead class="text-sm bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
          <tr>
            <th scope="col" class="px-6 py-3">
              Id
            </th>
            <th scope="col" class="px-6 py-3">
              Provider
            </th>
            <th scope="col" class="px-6 py-3">
              Projects
            </th>
            <th scope="col" class="px-6 py-3">
              Repos (In sync/total)
            </th>
            <th scope="col" class="px-6 py-3"></th>
          </tr>
        </thead>
        <tbody>
          <%= for org <- @organizations do %>
            <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 border-gray-200">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"
              >
                <a href={~p"/admin/organizations/#{org.id}"}>{org.external_id}</a>
              </th>
              <td class="px-6 py-4">
                {org.provider}
              </td>
              <td class="px-6 py-4">
                {org.total_projects}
              </td>
              <td class="px-6 py-4">
                {org.total_active_repos}/{org.total_repos}
              </td>
              <td>
                <button type="button" class="group p-2" aria-label={gettext("close")}>
                  <.icon name="hero-trash" class="h-5 w-5" />
                </button>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
