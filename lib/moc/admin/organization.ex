defmodule Moc.Admin.Organization do
  alias Moc.Connector
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :token, :string
    field :provider, Ecto.Enum, values: [:azure]
    field :external_id, :string
    has_many(:projects, Moc.Admin.Project)

    timestamps(type: :utc_datetime)
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
      changeset
      |> unsafe_validate_unique(:external_id, Moc.Repo)
      |> unique_constraint(:external_id)
    else
      changeset
    end
  end

  defp maybe_validate_token(changeset, opts) do
    if Keyword.get(opts, :validate_token, true) do
      validate_result =
        %Connector{
          organization_id: get_change(changeset, :external_id),
          provider: get_change(changeset, :provider),
          token: get_change(changeset, :token)
        }
        |> Connector.validate_token()

      case validate_result do
        :ok -> changeset
        :not_found -> add_error(changeset, :external_id, "not found")
        :unauthorized -> add_error(changeset, :token, "unauthorized")
      end
    else
      changeset
    end
  end
end
