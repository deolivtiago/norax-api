defmodule NoraxCore.Accounts.Users.User.Verify do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(code, %User{} = user) when is_binary(code) do
    with {:error, changeset} <- confirm_verification(code, user) do
      Map.new()
      |> Map.put(:user, type: :map)
      |> cast(%{user: changeset})
      |> then(&{:error, &1})
    end
  end

  defp confirm_verification(code, user) do
    changeset = User.changeset(user, %{verified?: true})

    if NimbleTOTP.valid?(user.otp_secret, code, period: 300) do
      changeset
      |> Repo.update!()
      |> then(&{:ok, &1})
    else
      changeset
      |> add_error(:code, "is invalid")
      |> then(&{:error, &1})
    end
  end
end
