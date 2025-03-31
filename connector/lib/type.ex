defmodule Moc.Connector.Type do
  @type t_project :: %{id: String.t(), name: String.t(), description: String.t(), url: String.t()}
  @type t_repository :: %{id: String.t(), name: String.t(), url: String.t()}
  @type t_pull_request :: %{
          id: integer(),
          repository_id: String.t(),
          title: String.t(),
          description: String.t(),
          status: String.t(),
          created_on: String.t(),
          completed_on: String.t(),
          source_branch: String.t(),
          target_branch: String.t(),
          is_draft: integer(),
          created_by: %{
            id: String.t(),
            name: String.t(),
            email: String.t()
          },
          reviewers:
            list(%{
              id: String.t(),
              name: String.t(),
              email: String.t(),
              vote: integer(),
              is_required: integer()
            }),
          completionOptions: %{
            delete_source_branch: String.t(),
            squash_merge: String.t(),
            merge_strategy: String.t()
          }
        }
end
