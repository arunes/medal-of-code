defmodule Moc.Contributors.ContributorActivity do
  use Ecto.Schema

  schema "contributor_activity" do
    field(:contributor_id, :integer)
    field(:date, :date)
  end
end
