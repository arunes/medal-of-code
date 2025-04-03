defmodule Moc.Sync.Type do
  @type provider :: :azure

  @type score_result :: %{
          counter_id: integer(),
          contributor_counter_id: integer() | nil,
          old_count: integer(),
          pull_request_id: integer(),
          repository_id: integer(),
          contributor_id: integer(),
          count: integer(),
          xp: float(),
          affinity: String.t(),
          dexterity: float(),
          wisdom: float(),
          charisma: float(),
          constitution: float()
        }

  @type counter_result_set :: %{
          counter_key: String.t(),
          counter_id: integer(),
          prs_ran_on: list(integer()),
          results: %{
            repository_id: pos_integer(),
            contributor_id: pos_integer(),
            contributor_counter_id: nil | integer(),
            old_count: non_neg_integer(),
            data:
              list(%{
                count: non_neg_integer(),
                pull_request_id: pos_integer(),
                xp: float(),
                affinity: String.t(),
                dexterity: non_neg_integer(),
                wisdom: non_neg_integer(),
                charisma: non_neg_integer(),
                constitution: non_neg_integer()
              })
          }
        }
end
