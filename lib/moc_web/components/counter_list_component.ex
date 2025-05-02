defmodule MocWeb.CounterListComponent do
  alias Moc.Scoring
  use MocWeb, :html

  attr :contributor_id, :integer, default: nil

  def counter_list(assigns) do
    counters = Scoring.get_counter_list(assigns.contributor_id)
    assigns = assigns |> assign(:counters, counters)

    ~H"""
    <.table hide_header id="counters" class="border-collapse table-auto w-full" rows={@counters}>
      <:col :let={item} class=" flex">
        {item.description}
      </:col>
      <:col :let={item} class=" text-right moc-text-3">
        {item.count}
      </:col>
    </.table>
    """
  end
end
