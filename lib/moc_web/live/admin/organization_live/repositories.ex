defmodule MocWeb.Admin.OrganizationLive.Repositories do
  use MocWeb, :live_view
  import MocWeb.Components.AdminNav

  def mount(params, _session, socket) do
    repositories = params["prj_id"] |> Moc.Admin.get_repository_list()

    socket =
      assign(socket,
        organization_id: params["org_id"],
        project_id: params["prj_id"],
        repositories: repositories
      )

    {:ok, socket}
  end

  def handle_event("toggle-sync", %{"repository_id" => repository_id}, socket) do
    enabled = Moc.Admin.toggle_sync(repository_id)

    new_repos =
      socket.assigns.repositories
      |> Enum.map(fn rp ->
        case rp.id == String.to_integer(repository_id) do
          true -> %{rp | sync_enabled: enabled}
          false -> rp
        end
      end)

    {:noreply,
     socket
     |> assign(:repositories, new_repos)
     |> put_flash(:info, "Sync settings updated successfully!")}
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
              Sync Enabled?
            </th>
            <th scope="col" class="px-6 py-3">
              Import After
            </th>
          </tr>
        </thead>
        <tbody>
          <%= for rp <- @repositories do %>
            <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 border-gray-200">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"
              >
                {rp.name}
              </th>
              <td class="px-6 py-4 text-sm">
                <button phx-click="toggle-sync" phx-value-repository_id={rp.id}>
                  <.icon :if={rp.sync_enabled} name="hero-check" class="h-5 w-5" />
                  <.icon :if={not rp.sync_enabled} name="hero-x-mark" class="h-5 w-5" />
                </button>
              </td>
              <td class="px-6 py-4">
                {Calendar.strftime(rp.cutoff_date, "%m/%d/%Y %I:%M %p")}
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
