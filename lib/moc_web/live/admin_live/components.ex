defmodule MocWeb.AdminLive.Components do
  use MocWeb, :html

  attr :selected_nav, :string, default: "dashboard"
  attr :breadcrumb, :list, default: nil
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

    assigns = assign(assigns, links: links) |> maybe_add_root_breadcrumb

    ~H"""
    <header>
      <ul class={[
        "flex flex-wrap text-sm font-medium text-center border-b border-moc-2 text-moc-2",
        !@breadcrumb && "mb-5"
      ]}>
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

      <ol :if={@breadcrumb} class="flex gap-2 mb-5 px-3 py-2 text-sm">
        <li><.icon name="hero-home" class="w-4 h-4 align-text-top" /></li>
        <%= for item <- Enum.intersperse(@breadcrumb, nil) do %>
          <li :if={item}>
            <span :if={item.link == ""}>{item.label}</span>
            <.link :if={item.link != ""} class="hover:underline" navigate={item.link}>
              {item.label}
            </.link>
          </li>
          <li :if={!item}><.icon name="hero-chevron-right align-text-top" class="w-4 h-4" /></li>
        <% end %>
      </ol>
    </header>
    {render_slot(@inner_block)}
    """
  end

  defp maybe_add_root_breadcrumb(%{breadcrumb: nil} = assigns), do: assigns

  defp maybe_add_root_breadcrumb(%{breadcrumb: breadcrumb} = assigns) do
    new_breadcrumb = [%{link: ~p"/admin", label: "Admin"} | breadcrumb]
    assigns |> assign(:breadcrumb, new_breadcrumb)
  end
end
