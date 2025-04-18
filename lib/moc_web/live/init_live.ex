defmodule MocWeb.InitLive do
  use MocWeb, :live_view
  alias Moc.Accounts
  alias Moc.Accounts.User
  alias Moc.Instance

  def mount(_params, _session, socket) do
    form = Accounts.change_user_registration(%User{}) |> to_form(as: "user")

    socket = assign(socket, form: form, trigger_submit: false)
    {:ok, socket, layout: {MocWeb.Layouts, :empty}}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Accounts.register_user(Map.put(params, "is_admin", true)) do
      {:ok, user} ->
        Instance.reload()
        form = Accounts.change_user_registration(user) |> to_form(as: "user")
        {:noreply, socket |> assign(form: form, trigger_submit: true)}

      {:error, %Ecto.Changeset{} = changeset} ->
        form = changeset |> to_form(as: "user")
        socket = assign(socket, :form, form)
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"user" => params}, socket) do
    form =
      Accounts.change_user_registration(%User{}, params)
      |> Map.put(:action, :validate)
      |> to_form(as: "user")

    socket = assign(socket, :form, form)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="bg-gray-50 dark:bg-gray-900">
      <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
        <div class="flex items-center mb-6 ">
          <.logo width={250} />
        </div>
        <div class="w-full bg-moc-1 rounded-lg shadow border-moc-3 md:mt-0 sm:max-w-md xl:p-0">
          <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
            <.title size={:xl}>
              Create an admin account
              <:subtitle>
                You need to create a default admin account to start using Medal of Code.
              </:subtitle>
            </.title>
            <.register_form form={@form} trigger_submit={@trigger_submit} />
          </div>
        </div>
      </div>
    </section>
    """
  end

  def register_form(assigns) do
    ~H"""
    <.form
      for={@form}
      id="register-form"
      phx-change="validate"
      phx-submit="save"
      phx-trigger-action={@trigger_submit}
      action={~p"/users/log_in?_action=registered"}
      method="post"
      novalidate
      class="space-y-4 md:space-y-6"
    >
      <.input type="email" field={@form[:email]} label="Your email" required />
      <.input type="password" field={@form[:password]} label="Password" required />
      <.input type="password" field={@form[:password_confirmation]} label="Confirm password" required />
      <.button class="w-full">Register</.button>
    </.form>
    """
  end
end
