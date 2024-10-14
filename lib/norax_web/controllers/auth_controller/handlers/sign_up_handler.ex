defmodule NoraxWeb.AuthController.SignUpHandler do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users
  alias NoraxWeb.AuthController.Params

  @doc false
  def validate_params(params), do: Params.validate(:signup, params, into: :attrs)

  def create_user(attrs), do: Users.create_user(attrs)
end
