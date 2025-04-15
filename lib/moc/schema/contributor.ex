defmodule Moc.Schema.Contributor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contributors" do
    field(:external_id, :string)
    field(:name, :string)
    field(:email, :string)
    field(:avatar, :string)
    field(:is_visible, :boolean)
    timestamps()
  end

  def create_changeset(contributor, params \\ %{}) do
    contributor
    |> cast(params, [
      :name,
      :external_id,
      :email
    ])
    |> validate_required([:name, :external_id])
  end
end
