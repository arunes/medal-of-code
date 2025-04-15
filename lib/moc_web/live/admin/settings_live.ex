defmodule MocWeb.Admin.SettingsLive do
  alias Moc.Runtime.Setup
  use MocWeb, :live_view
  import MocWeb.Components.AdminNav

  def render(assigns) do
    ~H"""
    <.admin_nav selected="settings" />
    <.simple_form class="" for={@form} phx-submit="save">
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

      <:actions>
        <.button>Save Settings</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    settings = Setup.get_settings()

    form =
      settings
      |> Enum.into(%{}, fn st -> {st.key, st.value} end)
      |> to_form(as: "settings")

    socket =
      assign(
        socket,
        settings: settings |> Enum.group_by(fn st -> st.category end),
        form: form
      )

    {:ok, socket}
  end

  def handle_event("save", %{"settings" => settings_params}, socket) do
    Setup.update_settings(settings_params)
    {:noreply, socket |> put_flash(:info, "Settings saved successfully!")}
  end
end
