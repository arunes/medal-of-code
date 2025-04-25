defmodule Moc.Scoring.Type do
  @type counter_result_set :: %{
          counter_key: String.t(),
          counter_id: pos_integer(),
          prs_ran_on: list(integer()),
          results: %{
            repository_id: pos_integer(),
            contributor_id: pos_integer(),
            contributor_counter_id: nil | pos_integer(),
            old_count: non_neg_integer(),
            data:
              list(%{
                count: non_neg_integer(),
                pull_request_id: pos_integer(),
                xp: float(),
                affinity: String.t(),
                dexterity: float(),
                wisdom: float(),
                charisma: float(),
                constitution: float()
              })
          }
        }

  @type medal_winner :: %{
          contributor_id: pos_integer(),
          medal_id: pos_integer()
        }
end
