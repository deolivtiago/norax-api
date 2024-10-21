defmodule NoraxWeb.AuthController.SignOut do
  @moduledoc false
  use NoraxWeb, :params

  alias NoraxCore.Accounts.AuthTokens

  defparams :signout do
    optional(:access_token, :string, trim: true)
    optional(:refresh_token, :string, trim: true)
  end

  def handle(params) do
    params
    |> validate()
    |> revoke_tokens()
  end

  defp validate(params), do: validate(:signout, params)

  defp revoke_tokens({:ok, user_auth}) do
    Enum.each(user_auth, &AuthTokens.revoke_auth_token/1)

    {:ok, user_auth}
  end

  defp revoke_tokens({:error, changeset}), do: {:error, changeset}
end
