defmodule MocWeb.AdminLive.Index do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components
  alias Moc.Sync

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Admin | Dashboard")
      |> set_sync_history()

    {:ok, socket}
  end

  def handle_event("sync", _params, socket) do
    Sync.sync()

    socket =
      socket
      |> put_flash(:info, "Sync finiched.")
      |> set_sync_history()

    {:noreply, socket}
  end

  defp set_sync_history(socket) do
    sync_history = Moc.Admin.get_sync_history_list()

    socket
    |> assign(:has_any_sync, Enum.any?(sync_history))
    |> stream(:sync_history, sync_history)
  end

  def render(assigns) do
    breadcrumb = [%{link: "", label: "Dashboard"}]
    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="dashboard" breadcrumb={@breadcrumb}>
      <.table
        :if={@has_any_sync}
        id="sync_history"
        rows={@streams.sync_history}
        row_id={fn {id, _row} -> id end}
        row_item={fn {_id, row} -> row end}
      >
        <:col :let={sync} align="left" label="Status">{sync.status}</:col>
        <:col :let={sync} align="right" label="Started At">
          <.local_datetime date={sync.inserted_at} />
        </:col>
        <:col :let={sync} align="right" label="Finished At">
          <.local_datetime date={sync.updated_at} />
        </:col>
        <:col :let={sync} align="center" label="Pull Requests">{sync.prs_imported}</:col>
        <:col :let={sync} align="center" label="Reviews">{sync.reviews_imported}</:col>
        <:col :let={sync} align="center" label="Comments">{sync.comments_imported}</:col>
        <:col :let={sync} align="left" label="Error Message">{sync.error_message || "N/A"}</:col>
      </.table>
      <div :if={!@has_any_sync} class="text-sm">
        No sync history found!, sync runs automatically once per hour. If you want to run sync manually, click the button below.
      </div>

      <div class="mt-5">
        <.button phx-click="sync">Run Sync</.button>
      </div>
    </.admin_content>
    """
  end
end
