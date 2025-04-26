defmodule Moc.Seeds do
  alias Moc.Admin.Settings
  import Ecto.Query
  alias Moc.Repo

  @spec run(Ecto.Repo.t()) :: :ok
  def run(_repo) do
    from(s in Settings, where: s.key == "db.initialized")
    |> Repo.exists?()
    |> maybe_run_seeds()
  end

  defp maybe_run_seeds(true), do: :ok

  defp maybe_run_seeds(false) do
    Moc.Seeds.Settings.run()
    Moc.Seeds.Levels.run()
    Moc.Seeds.Titles.run()
    Moc.Seeds.TitlePrefixes.run()
    Moc.Seeds.CountersAndMedals.run()
    :ok
  end
end
