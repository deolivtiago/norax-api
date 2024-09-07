defmodule NoraxCore.Accounts.Users.Services.ConfirmUser do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(%User{} = user, code) when is_binary(code) do
    if NimbleTOTP.valid?(user.otp_secret, code, period: 300) do
      user
      |> User.changeset(%{verified?: true})
      |> Repo.update!()
      |> then(&{:ok, &1})
    else
      user
      |> change(%{code: code})
      |> add_error(:code, "is invalid")
      |> then(&{:error, &1})
    end
  end
end
