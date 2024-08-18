defmodule NoraxCore.Accounts.OtpCodes do
  @moduledoc """
  `Accounts.OtpCodes` context.
  """

  alias NoraxCore.Accounts.OtpCodes.OtpCode

  defdelegate list_otp_codes(params), to: OtpCode.List, as: :call

  @doc """
  Creates an `OtpCode`

  ## Examples

      iex> create_otp_code(params)
      {:ok, %OtpCode{}}

      iex> create_otp_code(bad_params)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate create_otp_code(params), to: OtpCode.Create, as: :call

  @doc """
  Verifies an `OtpCode`

  ## Examples

      iex> verify_otp_code(code, email)
      {:ok, %OtpCode{}}

      iex> verify_otp_code(bad_code, email)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate verify_otp_code(code, email), to: OtpCode.Verify, as: :call

  @doc """
  Revokes an `OtpCode`

  ## Examples

      iex> revoke_otp_code(otp_code)
      {:ok, %OtpCode{}}

      iex> revoke_otp_code(bad_otp_code)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate revoke_otp_code(otp_code), to: OtpCode.Revoke, as: :call
end
