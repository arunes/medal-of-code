defmodule MocWeb.Admin.OrganizationLive.Form do
  alias Moc.Organization
  alias Moc.Organizations
  alias Moc.Schema
  use MocWeb, :live_view
  import MocWeb.Components.AdminNav

  def mount(_params, _session, socket) do
    changeset = Organizations.change_creation(%Schema.Organization{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "organization")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  def handle_event("save", %{"organization" => organization_params}, socket) do
    case Organizations.create_organization(organization_params) do
      {:ok, id} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization created successfully.")
         |> redirect(to: ~p"/admin/organizations/#{id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"organization" => organization_params}, socket) do
    changeset = Organizations.change_creation(%Schema.Organization{}, organization_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def render(assigns) do
    ~H"""
    <.admin_nav selected="organizations" />

    <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4 md:space-y-6">
      <.input type="select" field={@form[:provider]} options={[:azure]} label="Provider" />
      <.input type="text" field={@form[:external_id]} label="Identifier (Organization Id)" required />
      <.input type="text" field={@form[:token]} label="Token" required />
      <.button>Save</.button>
    </.form>
    """
  end
end
