defmodule MocWeb.Admin.OrganizationLive.Projects do
    use MocWeb, :live_view
  import MocWeb.Components.AdminNav

  def mount(params, _session, socket) do
    projects = params["org_id"] |> Moc.Admin.get_project_list()
    socket = assign(socket, organization_id: params["org_id"], projects: projects)
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
              Name
            </th>
            <th scope="col" class="px-6 py-3">
              Description
            </th>
            <th scope="col" class="px-6 py-3">
              Repos (In sync/total)
            </th>
          </tr>
        </thead>
        <tbody>
          <%= for prj <- @projects do %>
            <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 border-gray-200">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"
              >
                <a href={~p"/admin/organizations/#{@organization_id}/#{prj.id}"}>{prj.name}</a>
              </th>
              <td class="px-6 py-4 text-sm">
                {prj.description}
              </td>
              <td class="px-6 py-4">
                {prj.total_active_repos}/{prj.total_repos}
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

end
