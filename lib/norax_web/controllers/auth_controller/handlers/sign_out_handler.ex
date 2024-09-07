defmodule NoraxWeb.AuthController.SignOutHandler do
  alias NoraxWeb.AuthController.Params

  def validate_params(params) do
    with {:ok, auth} <- Params.validate(:signout, params) do
      Map.new()
      |> Map.put(:auth, auth)
      |> then(&{:ok, &1})
    end
  end

  def revoke_auth_tokens(auth), do: {:ok, auth}
end
