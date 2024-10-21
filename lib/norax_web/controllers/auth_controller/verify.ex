defmodule NoraxWeb.AuthController.Verify do
  @moduledoc false
  use NoraxWeb, :params

  alias NoraxCore.Accounts.Users

  defparams :send_code do
    required(:email, :string, format: :email, min: 3, max: 160, trim: true)
  end

  def handle(params) do
    params
    |> validate()
    |> verify_user()
  end

  defp validate(params), do: validate(:send_code, params)

  defp verify_user({:ok, %{email: email}}) do
    with {:ok, user} <- Users.get_user(:email, email) do
      Users.verify_user(user)
    end
  end

  defp verify_user({:error, changeset}), do: {:error, changeset}
end
