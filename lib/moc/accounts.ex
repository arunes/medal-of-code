defmodule Moc.Accounts do
  alias Moc.Repo
  alias Moc.Accounts.User

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    contributor = Repo.get_by(User, email: email)
    if User.valid_password?(contributor, password), do: contributor
  end

  def register_admin(params) do
    %User{is_admin: true}
    |> User.register_changeset(params)
    |> Repo.insert()
  end

  def change_registration(%User{} = contributor, attrs \\ %{}) do
    User.register_changeset(contributor, attrs,
      hash_password: false,
      validate_email: false
    )
  end
end
