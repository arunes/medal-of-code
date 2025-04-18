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

  slot :inner_block, required: true
  attr :size, :atom, values: [:lg, :xl], default: :lg
  slot :subtitle

  def title(assigns) do
    ~H"""
    <div class="col-span-full text-center mb-4">
      <h1 class={["text-moc-1", @size == :lg && "text-lg", @size == :xl && "text-xl"]}>
        {render_slot(@inner_block)}
      </h1>
      <p :if={@subtitle} class="text-sm text-moc-2 mt-2">{render_slot(@subtitle)}</p>
    </div>
    """
  end
end
