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
end
