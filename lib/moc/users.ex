defmodule Moc.Users do
  alias Moc.Repo
  alias Moc.Schema

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    contributor = Repo.get_by(Schema.User, email: email)
    if Schema.User.valid_password?(contributor, password), do: contributor
  end

  def register_admin(params) do
    %Schema.User{is_admin: true}
    |> Schema.User.register_changeset(params)
    |> Repo.insert()
  end

  def change_registration(%Schema.User{} = contributor, attrs \\ %{}) do
    Schema.User.register_changeset(contributor, attrs,
      hash_password: false,
      validate_email: false
    )
  end
end
