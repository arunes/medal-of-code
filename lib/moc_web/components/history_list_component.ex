defmodule MocWeb.HistoryListComponent do
  alias Moc.Utils
  use MocWeb, :html
  alias Moc.Scoring.Updates

  attr :contributor_id, :integer, default: nil
  attr :number_of_records, :integer, default: 20
  attr :current_contributor_id, :integer, required: true

  def history_list(assigns) do
    settings = Moc.Instance.get_settings()

    search_params = %{
      contributor_id: assigns.contributor_id,
      number_of_records: assigns.number_of_records,
      show_level: settings |> Utils.get_setting_value("contributor.show_level"),
      show_affinity: settings |> Utils.get_setting_value("contributor.show_affinity"),
      show_attributes: settings |> Utils.get_setting_value("contributor.show_attributes"),
      current_contributor_id: assigns.current_contributor_id
    }

    history = Updates.get_update_list(search_params)

    assigns =
      assigns
      |> assign(:history, history)

    ~H"""
    <.table
      :if={length(@history) > 0}
      hide_header
      id="history"
      class="border-collapse table-auto w-full"
      rows={@history |> Enum.with_index()}
      row_click={
        @contributor_id == nil &&
          fn {row, _} -> JS.navigate(~p"/contributors/#{row.contributor_id}") end
      }
    >
      <:col :let={{item, index}} class=" flex">
        <.row_content show_contributor={@contributor_id == nil} index={index} item={item} />
      </:col>
      <:col :let={{item, _}} class=" text-right moc-text-3">
        <.local_datetime date={item.inserted_at} />
      </:col>
    </.table>

    <p :if={length(@history) == 0} class="text-center text-moc-2">
      &quot;This stone remains unturned. The chronicles await the tales of valor
      yet to be etched by the keystrokes of destiny. Forge ahead, for history is
      written by those who dare to code.&quot;
    </p>
    """
  end

  defp row_content(%{show_contributor: true} = assigns) do
    ~H"""
    <.avatar
      id={@item.contributor_id + @index}
      size={24}
      name={@item.contributor_name}
      class="size-6 mr-3 align-middle"
    />
    <span>
      <a href={"/contributors/#{@item.contributor_id}"} class="font-bold">{@item.contributor_name}</a>
      <.update_row_message upper={false} item={@item} />
    </span>
    """
  end

  defp row_content(assigns) do
    ~H"""
    <span>
      <.update_row_message upper={true} item={@item} />
    </span>
    """
  end

  defp update_row_message(%{item: %{type: :medal_won}} = assigns),
    do: ~H"""
    <.word_with_case word="won" upper={@upper} />
    <a href={"/medals/#{@item.medal_id}"}>{@item.medal_name}</a> 🎖️
    """

  defp update_row_message(%{item: %{type: :xp_increase}} = assigns),
    do: ~H'<.word_with_case word="earned" upper={@upper} /> {@item.xp} xp 🚀'

  defp update_row_message(%{item: %{type: :level_up}} = assigns),
    do: ~H'<.word_with_case word="reached" upper={@upper} /> level {@item.level} ⬆️'

  defp update_row_message(%{item: %{type: :title_change}} = assigns),
    do: ~H'<.word_with_case word="earned" upper={@upper} /> the title {@item.title} 📜'

  defp update_row_message(%{item: %{type: :prefix_change}} = assigns),
    do: ~H'<.word_with_case word="earned" upper={@upper} /> the affinity {@item.prefix} 📜'

  defp update_row_message(%{item: %{type: :dexterity_increase}} = assigns),
    do: ~H'<.word_with_case word="gained" upper={@upper} /> +{@item.dexterity} dexterity 🏃'

  defp update_row_message(%{item: %{type: :charisma_increase}} = assigns),
    do: ~H'<.word_with_case word="gained" upper={@upper} /> +{@item.charisma} charisma 😎'

  defp update_row_message(%{item: %{type: :wisdom_increase}} = assigns),
    do: ~H'<.word_with_case word="gained" upper={@upper} /> +{@item.wisdom} wisdom 👴'

  defp update_row_message(%{item: %{type: :constitution_increase}} = assigns),
    do: ~H'<.word_with_case word="gained" upper={@upper} /> +{@item.constitution} constitution 🧍'

  defp word_with_case(%{upper: false} = assigns), do: ~H'{@word}'
  defp word_with_case(%{upper: true} = assigns), do: ~H'{@word |> String.capitalize()}'
end
