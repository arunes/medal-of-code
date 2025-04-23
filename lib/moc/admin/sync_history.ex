defmodule Moc.Admin.SyncHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sync_histories" do
    field :prs_imported, :integer
    field :pr_reviews_imported, :integer
    field :comments_imported, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sync_history, attrs) do
    sync_history
    |> cast(attrs, [:prs_imported, :pr_reviews_imported, :comments_imported])
    |> validate_required([:prs_imported, :pr_reviews_imported, :comments_imported])
  end
end
