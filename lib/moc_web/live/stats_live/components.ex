defmodule MocWeb.StatsLive.Components do
  use MocWeb, :html

  attr :id, :string, required: true
  attr :class, :string, default: ""

  def contribution_calendar(assigns) do
    format = assigns[:format] || "dateTime"
    assigns = assign(assigns, :format, format)

    ~H"""
    <moc-contribution-calendar class={@class} id={@id} phx-update="ignore" />
    """
  end
end
