defmodule MocWeb.ContributorActivityResponse do
  @derive Jason.Encoder
  defstruct [:date, :count]
end

defmodule MocWeb.ContributorController do
  use MocWeb, :controller
  alias Moc.Contributors

  def all_activity(conn, _) do
    activities =
      Contributors.get_all_activities()
      |> Enum.map(fn act ->
        %MocWeb.ContributorActivityResponse{
          date: act.date,
          count: act.count
        }
      end)

    render(conn, :activity, activities: activities)
  end

  def activity(conn, %{"id" => id}) do
    activities =
      Contributors.get_activities(id)
      |> Enum.map(fn act ->
        %MocWeb.ContributorActivityResponse{
          date: act.date,
          count: act.count
        }
      end)

    render(conn, :activity, activities: activities)
  end
end
