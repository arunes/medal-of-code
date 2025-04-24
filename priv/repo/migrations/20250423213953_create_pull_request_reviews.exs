defmodule Moc.Repo.Migrations.CreatePullRequestReviews do
  use Ecto.Migration

  def change do
    create table(:pull_request_reviews) do
      add :vote, :integer, null: false
      add :is_required, :boolean, null: false
      add :reviewer_id, references("contributors", on_delete: :delete_all), null: false
      add :pull_request_id, references("pull_requests", on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index("pull_request_reviews", [:reviewer_id])
    create index("pull_request_reviews", [:pull_request_id])
  end
end
