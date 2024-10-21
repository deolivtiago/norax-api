defmodule NoraxWeb.AuthController.SignIn do
  @moduledoc false
  use NoraxWeb, :params

  alias NoraxCore.Accounts.AuthTokens
  alias NoraxCore.Accounts.Users

  defparams :signin do
    required(:email, :string, format: :email, min: 3, max: 160, trim: true)
    required(:password, :string, trim: true)
  end

  def handle(params) do
    params
    |> validate()
    |> authenticate_user()
    |> create_tokens()
  end

  defp validate(params), do: validate(:signin, params)

  defp authenticate_user({:ok, user_attrs}), do: Users.authenticate_user(user_attrs)
  defp authenticate_user({:error, changeset}), do: {:error, changeset}

  defp create_tokens({:ok, user}) do
    with {:ok, access_token} <- AuthTokens.create_auth_token(user, :access),
         {:ok, refresh_token} <- AuthTokens.create_auth_token(user, :refresh) do
      Map.new()
      |> Map.put(:access_token, access_token.token)
      |> Map.put(:refresh_token, refresh_token.token)
      |> then(&{:ok, &1})
    end
  end

  defp create_tokens({:error, changeset}), do: {:error, changeset}
end
