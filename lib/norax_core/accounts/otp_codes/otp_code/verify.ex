defmodule NoraxCore.Accounts.OtpCodes.OtpCode.Verify do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.OtpCodes.OtpCode
  alias NoraxCore.Repo

  @doc false
  def call(code, email) when is_binary(code) and is_binary(email) do
    otp_code = Repo.get_by(OtpCode, email: email)

    if valid_code?(code, otp_code) do
      {:ok, otp_code}
    else
      OtpCode.changeset()
      |> change(%{email: email, code: code})
      |> add_error(:code, "is invalid")
      |> then(&{:error, &1})
    end
  end

  defp valid_code?(_code, nil), do: false
  defp valid_code?(code, %{secret: secret}), do: NimbleTOTP.valid?(secret, code, period: 300)
end
