defmodule NoraxCore.Accounts.OtpCodes.OtpCode.Create do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.OtpCodes.OtpCode
  alias NoraxCore.Repo

  @doc false
  def call(params) when is_map(params) do
    otp_code = Repo.get_by(OtpCode, email: params.email) || %OtpCode{}
    changeset = OtpCode.changeset(otp_code, params)

    with {:error, changeset} <- Repo.insert_or_update(changeset) do
      %{otp_code: [type: :map]}
      |> cast(%{otp_code: changeset})
      |> then(&{:error, &1})
    end
  end
end
