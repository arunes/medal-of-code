defmodule Moc.Sync.Counters.Type do
  defmodule Input do
    @type t :: %__MODULE__{
            id: pos_integer(),
            external_id: pos_integer(),
            title: String.t(),
            description: String.t(),
            status: String.t(),
            created_on: NaiveDateTime.t(),
            closed_on: NaiveDateTime.t(),
            source_branch: String.t(),
            target_branch: String.t(),
            is_draft: boolean,
            delete_source_branch: boolean,
            squash_merge: boolean,
            merge_strategy: String.t(),
            ready_for_use: boolean,
            comments_imported_on: NaiveDateTime.t(),
            created_by_id: pos_integer(),
            repository_id: pos_integer(),
            comments: [
              %{
                id: pos_integer(),
                external_id: pos_integer(),
                thread_id: pos_integer(),
                thread_status: String.t(),
                parent_comment_id: pos_integer(),
                content: String.t(),
                comment_type: String.t(),
                liked_by: String.t(),
                published_on: NaiveDateTime.t(),
                updated_on: NaiveDateTime.t(),
                created_by_id: pos_integer(),
                pull_request_id: pos_integer()
              }
            ],
            reviews: [
              %{
                id: pos_integer(),
                vote: integer(),
                is_required: boolean,
                reviewer_id: pos_integer(),
                pull_request_id: pos_integer()
              }
            ]
          }

    defstruct [
      :id,
      :external_id,
      :title,
      :description,
      :status,
      :created_on,
      :closed_on,
      :source_branch,
      :target_branch,
      :is_draft,
      :delete_source_branch,
      :squash_merge,
      :merge_strategy,
      :ready_for_use,
      :comments_imported_on,
      :comments,
      :reviews,
      :created_by_id,
      :repository_id
    ]
  end

  @type counter_result :: %{contributor_id: pos_integer(), count: non_neg_integer()}
end
