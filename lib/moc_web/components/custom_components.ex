defmodule MocWeb.CustomComponents do
  use Phoenix.Component
  use MocWeb, :verified_routes
  alias Phoenix.LiveView.JS

  attr :size, :integer, required: true
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def avatar(assigns) do
    ~H"""
    <img
      src="/images/avatar-placeholder.png"
      class={["rounded-full", @class]}
      width={@size}
      height={@size}
      alt={@name}
      phx-mounted={JS.dispatch("moc:set_avatar")}
    />
    """
  end

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
  attr :size, :string, values: ["lg", "xl", "xl2"], default: "lg"
  slot :subtitle

  def title(assigns) do
    ~H"""
    <div class="col-span-full text-center mb-4">
      <h1 class={[
        "text-moc-1",
        @size == "lg" && "text-lg",
        @size == "xl" && "text-xl",
        @size == "xl2" && "text-2xl"
      ]}>
        {render_slot(@inner_block)}
      </h1>
      <p :if={@subtitle} class="text-sm text-moc-2 mt-2">{render_slot(@subtitle)}</p>
    </div>
    """
  end
end
