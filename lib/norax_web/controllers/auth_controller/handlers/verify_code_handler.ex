defmodule NoraxWeb.AuthController.VerifyCodeHandler do
  alias NoraxCore.Accounts.Users
  alias NoraxWeb.AuthController.Params

  def validate_params(params), do: Params.validate(:verify_code, params)

  def get_user(email), do: Users.get_user(:email, email)

  def confirm_verification(user, code), do: Users.confirm_user(user, code)
end
