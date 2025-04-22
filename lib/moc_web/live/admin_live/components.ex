defmodule MocWeb.AdminLive.Components do
  use MocWeb, :html

  attr :selected_nav, :string, default: "dashboard"
  slot :inner_block, required: true

  def admin_content(assigns) do
    assigns = assign(assigns, :selected, true)

    links = [
      %{url: ~p"/admin", title: "Dashboard", active: assigns.selected_nav == "dashboard"},
      %{
        url: ~p"/admin/organizations",
        title: "Organizations",
        active: assigns.selected_nav == "organizations"
      },
      %{url: ~p"/admin/settings", title: "Settings", active: assigns.selected_nav == "settings"},
      %{url: ~p"/admin/users", title: "Users", active: assigns.selected_nav == "users"}
    ]

    assigns = assign(assigns, links: links)

    ~H"""
    <header>
      <ul class="mb-5 flex flex-wrap text-sm font-medium text-center border-b border-moc-2 text-moc-2">
        <li :for={link <- @links} class="me-2">
          <.link
            navigate={link.url}
            class={[
              "inline-block py-3 px-4 rounded-t-lg",
              link.active && "text-moc bg-moc-2 active",
              link.active && "hover:text-moc-2 hover:bg-moc-1"
            ]}
          >
            {link.title}
          </.link>
        </li>
      </ul>
    </header>
    {render_slot(@inner_block)}
    """
  end
end
