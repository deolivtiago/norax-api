defmodule NoraxWeb.AuthController.SignOutHandler do
  alias NoraxWeb.AuthController.Params

  def validate_params(params), do: Params.validate(:signout, params, into: :auth)

  def revoke_auth_tokens(auth), do: {:ok, auth}
end
