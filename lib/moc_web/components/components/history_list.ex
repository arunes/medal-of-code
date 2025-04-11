defmodule MocWeb.Components.HistoryList do
  use Phoenix.Component
  import Ecto.Query
  import MocWeb.Components.Avatar
  alias Phoenix.LiveView.JS
  alias Moc.Repo
  alias Moc.Schema

  def history_list(assigns) do
    history = query_history(assigns.contributor_id, assigns.number_of_records) |> Repo.all()
    assigns = assign(assigns, :history, history)

    ~H"""
    <table class="border-collapse table-auto w-full">
      <tbody class="bg-moc-1">
        <%= for item <- @history do %>
          <tr>
            <td class="border-b p-2 border-moc-2 flex">
              <.row_content contributor_id={@contributor_id} item={item} />
            </td>
            <td class="border-b p-2 border-moc-2 text-right moc-text-3">
              <span phx-mounted={JS.dispatch("moc:to_local_time")}>
                {Calendar.strftime(item.inserted_at, "%m/%d/%Y %I:%M %p")}
              </span>
            </td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  defp row_content(%{contributor_id: ""} = assigns) do
    ~H"""
    <.avatar size="24" alt={@item.contributor_name} class_name="size-6 mr-3 align-middle" />
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

  defp update_row_message(%{item: %{type: "medalWon"}} = assigns),
    do: ~H"""
    <.word_with_case word="won" upper={@upper} />
    <a href={"/medals/#{@item.medal_id}"}>{@item.medal_name}</a> 🎖️
    """

  defp update_row_message(%{item: %{type: "xpIncrease"}} = assigns),
    do: ~H'<.word_with_case word="earned" upper={@upper} /> {@item.xp} xp 🚀'

  defp update_row_message(%{item: %{type: "levelUp"}} = assigns),
    do: ~H'<.word_with_case word="reached" upper={@upper} /> level {@item.level} ⬆️'

  defp update_row_message(%{item: %{type: "titleChange"}} = assigns),
    do: ~H'<.word_with_case word="earned" upper={@upper} /> the title {@item.title} 📜'

  defp update_row_message(%{item: %{type: "prefixChange"}} = assigns),
    do: ~H'<.word_with_case word="earned" upper={@upper} /> the affinity {@item.prefix} 📜'

  defp update_row_message(%{item: %{type: "dexterityIncrease"}} = assigns),
    do: ~H'<.word_with_case word="gained" upper={@upper} /> +{@item.dexterity} dexterity 🏃'

  defp update_row_message(%{item: %{type: "charismaIncrease"}} = assigns),
    do: ~H'<.word_with_case word="gained" upper={@upper} /> +{@item.charisma} charisma 😎'

  defp update_row_message(%{item: %{type: "wisdomIncrease"}} = assigns),
    do: ~H'<.word_with_case word="gained" upper={@upper} /> +{@item.wisdom} wisdom 👴'

  defp update_row_message(%{item: %{type: "constitutionIncrease"}} = assigns),
    do: ~H'<.word_with_case word="gained" upper={@upper} /> +{@item.constitution} constitution 🧍'

  defp word_with_case(%{upper: false} = assigns), do: ~H'{@word}'
  defp word_with_case(%{upper: true} = assigns), do: ~H'{@word |> String.capitalize()}'

  # Queries
  defp query_history("", number_of_records), do: query_history_base(number_of_records)

  defp query_history(contributor_id, number_of_records) do
    query_history_base(number_of_records) |> where([u, c, m], u.contributor_id == ^contributor_id)
  end

  defp query_history_base(number_of_records) do
    from(upd in Schema.Update,
      join: cnt in assoc(upd, :contributor),
      left_join: md in assoc(upd, :medal),
      select: %{
        contributor_id: upd.contributor_id,
        contributor_name: cnt.name,
        xp: upd.xp,
        type: upd.type,
        level: upd.level,
        title: upd.title,
        prefix: upd.prefix,
        dexterity: upd.dexterity,
        charisma: upd.charisma,
        wisdom: upd.wisdom,
        constitution: upd.constitution,
        medal_id: upd.medal_id,
        medal_name: md.name,
        inserted_at: upd.inserted_at
      },
      limit: ^number_of_records,
      order_by: [desc: upd.inserted_at]
    )
  end
end

