defmodule NoraxWeb.AuthJSON do
  @moduledoc false

  alias NoraxCore.Accounts.OtpCodes.OtpCode

  @doc """
  Renders a list of otp_codes
  """
  def index(%{otp_codes: otp_codes}) do
    %{data: for(otp_code <- otp_codes, do: data(otp_code))}
  end

  @doc """
  Renders a single otp_code
  """
  def show(%{otp_code: otp_code}), do: %{data: data(otp_code)}

  defp data(%OtpCode{} = otp_code) do
    %{
      code: otp_code.code,
      email: otp_code.email
    }
  end
end
