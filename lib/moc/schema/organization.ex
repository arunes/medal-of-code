defmodule Moc.Schema.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias Moc.Schema.Project

  schema "organizations" do
    field(:provider, :string)
    field(:token, :string)
    field(:external_id, :string)
    has_many(:projects, Project)

    timestamps()
  end

  def create_changeset(organization, params, opts \\ []) do
    organization
    |> cast(params, [:provider, :token, :external_id])
    |> validate_id(opts)
    |> validate_token(opts)
  end

  defp validate_id(changeset, opts) do
    changeset
    |> validate_required([:external_id])
    |> maybe_validate_unique_id(opts)
  end

  defp validate_token(changeset, opts) do
    changeset
    |> validate_required([:token])
    |> maybe_validate_token(opts)
  end

  defp maybe_validate_unique_id(changeset, opts) do
    if Keyword.get(opts, :validate_id, true) do
      IO.puts("DEEP VALIDATION ID")

      changeset
      |> unsafe_validate_unique(:external_id, Moc.Repo)
      |> unique_constraint(:external_id)
    else
      IO.puts("SHALLOW VALIDATION ID")
      changeset
    end
  end

  defp maybe_validate_token(changeset, opts) do
    if Keyword.get(opts, :validate_token, true) do
      IO.puts("DEEP VALIDATION TOKEN")
      changeset
    else
      IO.puts("SHALLOW VALIDATION TOKEN")
      changeset
    end
  end
end
