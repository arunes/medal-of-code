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
    breadcrumb = [
      %{link: "/admin/organizations", label: "Organizations"},
      %{link: "", label: "Add Organization"}
    ]

    assigns = assign(assigns, :breadcrumb, breadcrumb)

    ~H"""
    <.admin_content selected_nav="organizations" breadcrumb={@breadcrumb}>
      <div class="flex-none md:flex md:gap-10">
        <div class="w-1/2">
          <.create_form form={@form} />
        </div>
        <div class="w-1/2">
          <p>
            1. Get the organization id from your devops url,
            <img src="/images/azure-org-name.png" width="350px" class="block my-1" />
            <small>'myorganization' is the organization id.</small>
          </p>
          <p class="mt-6">
            2. Get the token by creating PAT (Personal Access Token) by following <a
              href="https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows#create-a-pat"
              class="underline"
              target="_blank"
            >these instructions</a>.
            <small class="block mt-2">
              Medal of Code requires <strong>read</strong>
              permissions on <strong>Code</strong>
              section.
            </small>
          </p>
        </div>
      </div>
    </.admin_content>
    """
  end

  defp create_form(assigns) do
    ~H"""
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
      <.button>Create</.button>
    </.form>
    """
  end
end
