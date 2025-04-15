defmodule MocWeb.Admin.InitLive do
  use MocWeb, :live_view
  alias Moc.Runtime.Setup
  alias Moc.Users
  alias Moc.Schema

  def render(assigns) do
    ~H"""
    <section class="bg-gray-50 dark:bg-gray-900">
      <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
        <a
          href="#"
          class="flex items-center mb-6 text-2xl font-semibold text-gray-900 dark:text-white"
        >
          <img
            src={~p"/images/logo-light.png"}
            width="250"
            class="hidden dark:block"
            alt="Medal of Code"
          />
          <img src={~p"/images/logo-dark.png"} width="250" class="dark:hidden" alt="Medal of Code" />
        </a>
        <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
          <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
            <.header class="text-center">Create an admin account</.header>
            <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4 md:space-y-6">
              <.input type="email" field={@form[:email]} label="Your email" required />
              <.input type="password" field={@form[:password]} label="Password" required />
              <.input
                type="password"
                field={@form[:password_confirmation]}
                label="Confirm password"
                required
              />
              <.button class="w-full">Register</.button>
            </.form>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Users.change_registration(%Schema.User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil], layout: false}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.register_admin(user_params) do
      {:ok, _} ->
        Setup.reload()

        {:noreply,
         socket
         |> put_flash(:info, "Admin account created successfully.")
         |> redirect(to: ~p"/admin")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_registration(%Schema.User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
