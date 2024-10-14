defmodule NoraxCore.Accounts.Users.Services.AuthenticateUser do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(credentials) when is_map(credentials) do
    with {:ok, %User{verified?: false} = user} <- verify_credentials(credentials) do
      user
      |> change()
      |> add_error(:email, "must be verified")
      |> then(&{:error, &1})
    end
  end

  defp verify_credentials(%{email: email, password: password}) do
    user = Repo.get_by(User, email: email)

    if valid_password?(user, password) do
      {:ok, user}
    else
      User.changeset()
      |> change(%{password: password})
      |> add_error(:email, "is incorrect")
      |> add_error(:password, "is incorrect")
      |> then(&{:error, &1})
    end
  end

  defp valid_password?(%User{password: hash}, password), do: Argon2.verify_pass(password, hash)
  defp valid_password?(nil, _password), do: Argon2.no_user_verify()
end
