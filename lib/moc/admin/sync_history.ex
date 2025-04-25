defmodule Moc.Admin.SyncHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sync_histories" do
    field :prs_imported, :integer
    field :reviews_imported, :integer
    field :comments_imported, :integer
    field :error_message, :string
    field :status, Ecto.Enum, values: [:importing, :finished, :failed]

    timestamps(type: :utc_datetime)
  end

  def create_changeset(sync_history, attrs \\ %{}) do
    sync_history |> cast(attrs, [])
  end

  def update_changeset(sync_history, attrs) do
    sync_history
    |> cast(attrs, [
      :prs_imported,
      :reviews_imported,
      :comments_imported,
      :error_message,
      :status
    ])
    |> validate_required([:prs_imported, :reviews_imported, :comments_imported, :status])
  end
end
