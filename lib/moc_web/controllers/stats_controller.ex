defmodule MocWeb.StatsController do
  alias Moc.Stats
  use MocWeb, :controller

  def index(conn, _params) do
    # total prs
    # first pr date
    # last pr date
    # avg pr completion
    # pr per day
    # total open pr time
    # total comments
    # total votes

    # git activity chart

    # counters
    # main counters

    # active repo list

    repositories = Stats.list_repositories()

    render(conn, :index, repositories: repositories)
  end
end
