defmodule Moc.Schema.ContributorActivity do
  use Ecto.Schema

  schema "contributor_activity" do
    field(:unique_id, :string)
    field(:contributor_id, :integer)
    field(:date, :date)
  end

  # @primary_key false
end
