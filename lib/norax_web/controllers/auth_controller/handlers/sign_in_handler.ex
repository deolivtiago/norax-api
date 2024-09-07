defmodule NoraxWeb.AuthController.SignInHandler do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.AuthTokens
  alias NoraxCore.Accounts.Users
  alias NoraxWeb.AuthController.Params

  def validate_params(params) do
    with {:ok, attrs} <- Params.validate(:signin, params) do
      Map.new()
      |> Map.put(:attrs, attrs)
      |> then(&{:ok, &1})
    end
  end

  def authenticate_user(user_attrs), do: Users.authenticate_user(user_attrs)

  def generate_auth_tokens(user) do
    with {:ok, access_token} <- AuthTokens.create_auth_token(user, :access),
         {:ok, refresh_token} <- AuthTokens.create_auth_token(user, :refresh) do
      Map.new()
      |> Map.put(:access_token, access_token.token)
      |> Map.put(:refresh_token, refresh_token.token)
      |> then(&{:ok, &1})
    end
  end
end
