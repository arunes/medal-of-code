defmodule Moc.Medal do
  defstruct [:id, :name, :description, :affinity]
end

defmodule Moc.Medals do
  import Ecto.Query
  alias Moc.Schema.Medal
  alias Moc.Repo

  def get_list() do
    query_all() |> Repo.all()
  end

  def get_medal(id) do
    query_get_medal(id) |> Repo.one!()
  end

  # queries
  def query_all() do
    from(md in Medal)
  end

  def query_get_medal(id) when is_integer(id) do
    from(md in Medal,
      where: md.id == ^id
    )
  end

  def query_get_medal(id) when is_binary(id) do
    id |> String.to_integer() |> query_get_medal()
  end
end
