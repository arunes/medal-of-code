defmodule Moc.PullRequests.PullRequestComment do
  use Ecto.Schema

  schema "pull_request_comments" do
    field :external_id, :integer
    field :thread_id, :integer

    field :thread_status, Ecto.Enum,
      values: [:active, :byDesign, :closed, :fixed, :pending, :unknown, :wontFix]

    field :parent_comment_id, :integer
    field :content, :string
    field :comment_type, Ecto.Enum, values: [:codeChange, :system, :text, :unknown]
    field :liked_by, :string
    field :published_on, :utc_datetime
    field :updated_on, :utc_datetime

    belongs_to :created_by, Moc.Contributors.Contributor
    belongs_to :pull_request, Moc.PullRequests.PullRequest

    timestamps(type: :utc_datetime)
  end
end
