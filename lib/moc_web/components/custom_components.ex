defmodule MocWeb.CustomComponents do
  use Phoenix.Component
  use MocWeb, :verified_routes

  attr :width, :integer, required: true

  def logo(assigns) do
    ~H"""
    <img
      src={~p"/images/logo-light.png"}
      width={@width}
      alt="Medal of Code"
      class="mx-auto h-auto hidden dark:block"
    />
    <img
      src={~p"/images/logo-dark.png"}
      width={@width}
      alt="Medal of Code"
      class="mx-auto h-auto dark:hidden"
    />
    """
  end
end
