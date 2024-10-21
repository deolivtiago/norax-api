defmodule NoraxWeb.AuthController.SignUp do
  @moduledoc false
  use NoraxWeb, :params

  alias NoraxCore.Accounts.AuthTokens
  alias NoraxCore.Accounts.Users

  defparams :signup do
    required(:first_name, :string, min: 2, max: 255, squish: true)
    optional(:last_name, :string, max: 255, squish: true)

    required(:email, :string, format: :email, min: 3, max: 160, trim: true)
    required(:password, :string, format: :password, min: 6, max: 72, trim: true)

    optional(:avatar_url, :string, format: :url, max: 255)
    optional(:role, :enum, values: ~w(user admin))
  end

  def handle(params) do
    params
    |> validate()
    |> create_user()
    |> create_tokens()
  end

  defp validate(params), do: validate(:signup, params)

  defp create_user({:ok, user_attrs}), do: Users.create_user(user_attrs)
  defp create_user({:error, changeset}), do: {:error, changeset}

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
