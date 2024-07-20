defmodule NoraxCore.Accounts.Users.Services.AuthenticateUser do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(%{email: email, password: password}) do
    user = Repo.get_by(User, email: email)

    with {:ok, %User{verified?: false}} <- verify_credentials(user, password) do
      user
      |> change()
      |> add_error(:email, "must be verified")
      |> then(&{:error, &1})
    end
  end

  defp verify_credentials(user, password) do
    valid_credentials? =
      if is_nil(user),
        do: Argon2.no_user_verify(),
        else: Argon2.verify_pass(password, user.password)

    if valid_credentials? do
      {:ok, user}
    else
      User.changeset()
      |> change(%{password: password})
      |> add_error(:email, "is incorrect")
      |> add_error(:password, "is incorrect")
      |> then(&{:error, &1})
    end
  end
end
