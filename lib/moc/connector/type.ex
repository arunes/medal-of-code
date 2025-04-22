defmodule Moc.Connector.Type do
  @type provider :: :azure
  @type contributor :: %{id: String.t(), name: String.t(), email: String.t()}
  @type project :: %{id: String.t(), name: String.t(), description: String.t(), url: String.t()}
  @type repository :: %{id: String.t(), name: String.t(), url: String.t()}
  @type pull_request :: %{
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
          created_by: contributor(),
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

  @type comment :: %{
          id: integer(),
          parent_comment_id: integer(),
          content: String.t(),
          comment_type: String.t(),
          published_on: String.t(),
          updated_on: String.t(),
          created_by: contributor(),
          users_liked: list(contributor())
        }

  @type thread :: %{
          id: integer(),
          status: String.t(),
          comments: list(comment())
        }
end
