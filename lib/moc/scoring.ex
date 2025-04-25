defmodule Moc.Scoring do
  alias Moc.Repo
  alias Moc.Scoring.Counters

  def calculate() do
    Counters.get_result_sets()
    |> save_results()
  end

  defp save_results([]), do: :ok

  defp save_results([result_set | rest]) do
    Repo.transaction(fn ->
      result_set
      |> Counters.save_result_set()

      # 2. save results to db
      # 3. award xp
      # 4. update prs
      # 5. award medals
      # 6. save updates
    end)

    save_results(rest)
  end
end
