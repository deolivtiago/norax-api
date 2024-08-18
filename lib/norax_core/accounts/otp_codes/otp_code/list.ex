defmodule NoraxCore.Accounts.OtpCodes.OtpCode.List do
  @moduledoc false

  alias NoraxCore.Accounts.OtpCodes.OtpCode
  alias NoraxCore.Repo

  @doc false
  def call(params), do: Repo.all(OtpCode, params)
end
