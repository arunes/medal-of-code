defmodule MocWeb.Components.Avatar do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def avatar(assigns) do
    ~H"""
    <img
      src="/images/avatar-placeholder.png"
      class={"rounded-full #{@class_name}"}
      width={@size}
      height={@size}
      alt={@alt}
      phx-mounted={JS.dispatch("moc:set_avatar")}
    />
    """
  end
end
