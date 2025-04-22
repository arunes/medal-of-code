defmodule MocWeb.AdminNav do
  use MocWeb, :html

  def admin_nav(assigns) do
    assigns = assign(assigns, :selected, true)

    links = [
      %{url: ~p"/admin", title: "Dashboard"},
      %{
        url: ~p"/admin/organizations",
        title: "Organizations"
      },
      %{url: ~p"/admin/settings", title: "Settings"},
      %{url: ~p"/admin/users", title: "Users"}
    ]

    assigns = assign(assigns, links: links)

    ~H"""
    <header>
      <ul
        class="mb-5 flex flex-wrap text-sm font-medium text-center border-b border-moc-2 text-moc-2"
        phx-mounted={JS.dispatch("moc:admin_select_active")}
      >
        <li :for={link <- @links} class="me-2">
          <.link navigate={link.url} class="inline-block py-3 px-4 rounded-t-lg">
            {link.title}
          </.link>
        </li>
      </ul>
    </header>
    """
  end
end
