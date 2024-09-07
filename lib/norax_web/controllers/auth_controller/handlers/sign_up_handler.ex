defmodule NoraxWeb.AuthController.SignUpHandler do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users
  alias NoraxWeb.AuthController.Params

  @doc false
  def validate_params(params) do
    with {:ok, attrs} <- Params.validate(:signup, params) do
      Map.new()
      |> Map.put(:attrs, attrs)
      |> then(&{:ok, &1})
    end
  end

  def create_user(attrs), do: Users.create_user(attrs)
end
