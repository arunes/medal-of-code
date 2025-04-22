defmodule MocWeb.AdminLive.Organization.Create do
  use MocWeb, :live_view
  import MocWeb.AdminLive.Components
  alias Moc.Admin.Organization
  alias Moc.Admin

  def mount(_params, _session, socket) do
    form = Admin.change_create_organization(%Organization{}) |> to_form(as: "organization")

    socket =
      socket
      |> assign(:page_title, "New Organization")
      |> assign(:form, form)

    {:ok, socket}
  end

  def handle_event("save", %{"organization" => params}, socket) do
    case Admin.create_organization(params) do
      {:ok, organization} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization created successfully.")
         |> redirect(to: ~p"/admin/organizations/#{organization}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        form = changeset |> to_form(as: "organization")
        socket = assign(socket, :form, form)
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"organization" => params}, socket) do
    form =
      Admin.change_create_organization(%Organization{}, params)
      |> Map.put(:action, :validate)
      |> to_form(as: "organization")

    socket = assign(socket, :form, form)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.admin_content selected_nav="organizations">
      <.form
        for={@form}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4 md:space-y-6"
        novalidate
      >
        <.input type="select" field={@form[:provider]} options={[:azure]} label="Provider" />
        <.input type="text" field={@form[:external_id]} label="Identifier (Organization Id)" required />
        <.input type="text" field={@form[:token]} label="Token" required />
        <.button>Save</.button>
      </.form>
    </.admin_content>
    """
  end
end
