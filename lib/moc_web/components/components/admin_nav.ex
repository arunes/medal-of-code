defmodule MocWeb.Components.AdminNav do
  use Phoenix.Component

  def admin_nav(assigns) do
    ~H"""
    <ul class="mb-5 flex flex-wrap text-sm font-medium text-center text-gray-500 border-b border-gray-200 dark:border-gray-700 dark:text-gray-400">
      <li class="me-2">
        <.admin_link link="/admin" title="Organizations" selected={@selected == "organizations"} />
      </li>
      <li class="me-2">
        <.admin_link link="/admin/settings" title="Settings" selected={@selected == "settings"} />
      </li>
    </ul>
    """
  end

  defp admin_link(%{selected: true} = assigns) do
    ~H"""
    <a
      href={@link}
      aria-current="page"
      class="inline-block p-4 text-blue-600 bg-gray-100 rounded-t-lg active dark:bg-gray-800 dark:text-blue-500"
    >
      {@title}
    </a>
    """
  end

  defp admin_link(%{selected: false} = assigns) do
    ~H"""
    <a
      href={@link}
      aria-current="page"
      class="inline-block p-4 rounded-t-lg hover:text-gray-600 hover:bg-gray-50 dark:hover:bg-gray-800 dark:hover:text-gray-300"
    >
      {@title}
    </a>
    """
  end
end
