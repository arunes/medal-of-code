defmodule MocWeb.Components.Common do
  use Phoenix.Component

  def title(assigns) do
    ~H"""
    <h1 class="col-span-full text-center text-3xl mb-4">{@title}</h1>
    """
  end
end
