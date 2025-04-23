defmodule MocWeb.AdminLive.Settings do
  alias Moc.Instance
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components

  def mount(_params, _session, socket) do
    settings = Instance.get_settings()

    form =
      settings
      |> Enum.into(%{}, fn st -> {st.key, st.value} end)
      |> to_form(as: "settings")

    grouped_settings = Enum.group_by(settings, fn st -> st.category end)

    socket =
      socket
      |> assign(:page_title, "Settings | Admin")
      |> assign(:settings, grouped_settings)
      |> assign(:form, form)

    {:ok, socket}
  end

  def handle_event("save", %{"settings" => params}, socket) do
    Instance.update_settings(params)
    {:noreply, socket |> put_flash(:info, "Settings saved successfully!")}
  end

  def render(assigns) do
    breadcrumb = [%{link: "", label: "Settings"}]
    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="settings" breadcrumb={@breadcrumb}>
      <.form for={@form} phx-submit="save" class="space-y-4 md:space-y-6" novalidate>
        <div class="grid grid-cols-1 md:grid-cols-3">
          <%= for {category, settings} <- @settings do %>
            <div>
              <h2 class="mb-2">{category}</h2>
              <%= for setting <- settings do %>
                <.input type="checkbox" field={@form[setting.key]} label={setting.description} />
              <% end %>
            </div>
          <% end %>
        </div>

        <.button>Save</.button>
      </.form>
    </.admin_content>
    """
  end
end
