defmodule MocWeb.UserLoginLive do
  use MocWeb, :live_view

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    socket = assign(socket, form: form)
    {:ok, socket, temporary_assigns: [form: form], layout: {MocWeb.Layouts, :empty}}
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
            <.title size="xl">
              Login
              <:subtitle>
                If you don't have an account or forgot your password, please reach out to system admin.
              </:subtitle>
            </.title>
            <.login_form form={@form} />
          </div>
        </div>
      </div>
    </section>
    """
  end

  def login_form(assigns) do
    ~H"""
    <.form
      for={@form}
      id="login-form"
      action={~p"/users/log_in"}
      novalidate
      class="space-y-4 md:space-y-6"
      phx-update="ignore"
    >
      <.input field={@form[:email]} type="email" label="Email" required />
      <.input field={@form[:password]} type="password" label="Password" required />
      <.button phx-disable-with="Logging in..." class="w-full">
        Log in <span aria-hidden="true">→</span>
      </.button>
    </.form>
    """
  end
end
