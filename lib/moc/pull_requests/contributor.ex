defmodule Moc.PullRequests.Contributor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contributors" do
    field(:external_id, :string)
    field(:name, :string)
    field(:email, :string)
    field(:is_visible, :boolean)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contributors, attrs) do
    contributors
    |> cast(attrs, [:name, :external_id, :email])
    |> validate_required([:name, :external_id])
  end
end
