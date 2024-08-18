defmodule NoraxCore.Accounts.OtpCodes.OtpCode.Revoke do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.OtpCodes.OtpCode
  alias NoraxCore.Repo

  @opts [stale_error_field: :email, stale_error_message: "not found"]

  @doc false
  def call(%OtpCode{} = otp_code) do
    with {:error, changeset} <- Repo.delete(otp_code, @opts) do
      %{otp_code: [type: :map]}
      |> cast(%{otp_code: changeset})
      |> then(&{:error, &1})
    end
  end
end
