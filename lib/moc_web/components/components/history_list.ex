defmodule MocWeb.Components.HistoryList do
  use Phoenix.Component
  import Ecto.Query
  alias Moc.Repo
  alias Moc.Schema

  def history_list(assigns) do
    history = query_history(assigns.contributor_id, assigns.number_of_records) |> Repo.all()
    assigns = assign(assigns, :history, history)

    ~H"""
    <div>this is history</div>
    {inspect(@history)}
    """
  end

  defp query_history("", number_of_records), do: query_history_base(number_of_records)

  defp query_history(contributor_id, number_of_records) do
    query_history_base(number_of_records) |> where([u, c, m], u.contributor_id == ^contributor_id)
  end

  defp query_history_base(number_of_records) do
    from(upd in Schema.Update,
      join: cnt in assoc(upd, :contributor),
      join: md in assoc(upd, :medal),
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
