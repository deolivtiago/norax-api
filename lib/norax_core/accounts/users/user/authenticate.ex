defmodule NoraxCore.Accounts.Users.User.Authenticate do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User

  @doc false
  def call(%User{} = user, password) when is_binary(password) do
    with {:ok, %User{verified?: false}} <- validate_password(password, user) do
      changeset = change(user) |> add_error(:email, "must be verified")

      Map.new()
      |> Map.put(:user, type: :map)
      |> cast(%{user: changeset})
      |> then(&{:error, &1})
    end
  end

  defp validate_password(password, user) when is_binary(password) do
    if Argon2.verify_pass(password, user.password) do
      {:ok, user}
    else
      changeset =
        change(user)
        |> add_error(:email, "is incorrect")
        |> add_error(:password, "is incorrect")

      Map.new()
      |> Map.put(:user, type: :map)
      |> cast(%{user: changeset})
      |> then(&{:error, &1})
    end
  end
end
