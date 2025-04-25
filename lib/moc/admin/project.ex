defmodule Moc.Admin.Project do
  use Ecto.Schema

  schema "projects" do
    field :external_id, :string
    field :name, :string
    field :description, :string
    field :url, :string

    belongs_to(:organization, Moc.Admin.Organization)
    has_many(:repositories, Moc.Admin.Repository)

    timestamps(type: :utc_datetime)
  end
end
