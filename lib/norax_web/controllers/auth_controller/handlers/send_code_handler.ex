defmodule NoraxWeb.AuthController.SendCodeHandler do
  alias NoraxCore.Accounts.Users
  alias NoraxWeb.AuthController.Params

  def validate_params(params), do: Params.validate(:send_code, params)

  def get_user(email), do: Users.get_user(:email, email)

  def send_verification(user), do: Users.verify_user(user)
end
