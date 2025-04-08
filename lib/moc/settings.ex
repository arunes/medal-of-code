defmodule Moc.Settings do
  require Logger
  use Agent

  @me __MODULE__

  @type t :: %__MODULE__{
          leaderboard: %{
            all_time_stats: boolean(),
            negative_lists: boolean()
          },
          contributors: %{
            ranks: boolean(),
            medalCounts: boolean(),
            levels: boolean(),
            attributes: boolean(),
            affinity: boolean(),
            activity: %{
              numbers: boolean(),
              calendar: boolean(),
              wordcloud: boolean(),
              stats: boolean()
            },
            history: boolean()
          }
        }

  defstruct leaderboard: %{
              all_time_stats: true,
              negative_lists: true
            },
            contributors: %{
              ranks: true,
              medalCounts: true,
              levels: true,
              attributes: true,
              affinity: true,
              activity: %{
                numbers: true,
                calendar: true,
                wordcloud: true,
                stats: true
              },
              history: true
            }

  def start_link(_args) do
    Logger.info("Starting settings process. '#{@me}'")
    Agent.start_link(fn -> %__MODULE__{} end, name: @me)
  end

  def get() do
    Agent.get(@me, fn settings -> settings end)
  end
end
