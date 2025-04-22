defmodule MocWeb.Nav do
  alias Moc.Accounts
  use MocWeb, :html
  alias Phoenix.LiveView.JS

  attr :selected_nav, :string, default: "home"
  attr :user, Accounts.User, default: nil

  def nav(assigns) do
    links = [
      %{title: "LEADERBOARD", path: ~p"/leaderboard"},
      %{title: "CONTRIBUTORS", path: ~p"/contributors"},
      %{title: "MEDALS", path: ~p"/medals"},
      %{title: "STATS", path: ~p"/stats"}
    ]

    assigns = assign(assigns, links: links)

    ~H"""
    <nav class="navbar">
      <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto px-4 py-3">
        <.link navigate={~p"/"}>
          <.logo width={200} />
        </.link>
        <div class="flex-grow"></div>
        <button
          data-collapse-toggle="navbar-default"
          type="button"
          class="inline-flex items-center p-2 w-10 h-10 justify-center text-sm rounded-lg md:hidden focus:outline-none focus:ring-2"
          aria-controls="navbar-default"
          aria-expanded="false"
        >
          <span class="sr-only">Open main menu</span>
          <svg
            class="w-5 h-5"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 17 14"
          >
            <path
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M1 1h15M1 7h15M1 13h15"
            />
          </svg>
        </button>
        <div class={["w-full md:block md:w-auto"]} id="navbar-default">
          <ul class="font-medium flex flex-col mt-4 md:flex-row space-y-2 md:space-y-0 md:space-x-2 rtl:space-x-reverse md:mt-0 md:border-0">
            <li>
              <.theme_switch />
            </li>
            <li :for={link <- @links} class="flex flex-col justify-center">
              <.link
                navigate={link.path}
                class={["px-3 py-2 hover:bg-moc-2 rounded-lg hover:no-underline", "active"]}
              >
                {link.title}
              </.link>
            </li>
            <li class="flex flex-col justify-center">
              <.link href={~p"/users/log_out"} method="delete">
                <.icon name="hero-arrow-right-start-on-rectangle" />
              </.link>
            </li>
          </ul>
        </div>
      </div>
    </nav>
    """
  end

  defp theme_switch(assigns) do
    ~H"""
    <div class="flex flex-col justify-center" phx-click={JS.dispatch("toggle-darkmode")}>
      <input
        type="checkbox"
        id="light-switch"
        class="light-switch sr-only"
        phx-click={JS.dispatch("toggle-darkmode")}
      />
      <label
        htmlFor="light-switch"
        class="md:hidden block w-full cursor-pointer px-3 py-2 hover:bg-moc-2 rounded-lg"
      >
        <span class="dark:hidden">DARK MODE</span>
        <span class="hidden dark:inline">LIGHT MODE</span>
      </label>
      <label class="hidden md:block relative cursor-pointer mt-3" htmlFor="light-switch">
        <svg class="dark:hidden" width="16" height="16" xmlns="http://www.w3.org/2000/svg">
          <path
            class="fill-slate-300"
            d="M7 0h2v2H7zM12.88 1.637l1.414 1.415-1.415 1.413-1.413-1.414zM14 7h2v2h-2zM12.95 14.433l-1.414-1.413 1.413-1.415 1.415 1.414zM7 14h2v2H7zM2.98 14.364l-1.413-1.415 1.414-1.414 1.414 1.415zM0 7h2v2H0zM3.05 1.706 4.463 3.12 3.05 4.535 1.636 3.12z"
          />
          <path class="fill-slate-400" d="M8 4C5.8 4 4 5.8 4 8s1.8 4 4 4 4-1.8 4-4-1.8-4-4-4Z" />
        </svg>
        <svg class="hidden dark:block" width="16" height="16" xmlns="http://www.w3.org/2000/svg">
          <path
            class="fill-slate-400"
            d="M6.2 1C3.2 1.8 1 4.6 1 7.9 1 11.8 4.2 15 8.1 15c3.3 0 6-2.2 6.9-5.2C9.7 11.2 4.8 6.3 6.2 1Z"
          />
          <path
            class="fill-slate-500"
            d="M12.5 5a.625.625 0 0 1-.625-.625 1.252 1.252 0 0 0-1.25-1.25.625.625 0 1 1 0-1.25 1.252 1.252 0 0 0 1.25-1.25.625.625 0 1 1 1.25 0c.001.69.56 1.249 1.25 1.25a.625.625 0 1 1 0 1.25c-.69.001-1.249.56-1.25 1.25A.625.625 0 0 1 12.5 5Z"
          />
        </svg>
        <span class="sr-only">Switch to light / dark version</span>
      </label>
    </div>
    """
  end
end
