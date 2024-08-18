defmodule NoraxCore.Accounts.OtpCodes.OtpCode do
  @moduledoc """
  `OtpCode` schema
  """
  use NoraxCore, :schema

  alias __MODULE__

  @primary_key {:email, :string, autogenerate: false}

  schema "otp_codes" do
    field :secret, :binary, autogenerate: {NimbleTOTP, :secret, []}

    field :code, :string,
      autogenerate: {NimbleTOTP, :verification_code, [NimbleTOTP.secret(), period: 300]}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(otp_code \\ %OtpCode{}, params) when is_map(params) do
    secret = NimbleTOTP.secret()

    otp_code
    |> cast(params, ~w(email secret code)a)
    |> validate_required(:email)
    |> unique_constraint(:email, name: :otp_codes_pkey)
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 3, max: 160)
    |> validate_format(:email, ~r/^[.!?@#$%^&*_+a-z\-0-9]+[@][._+\-a-z0-9]+$/)
    |> validate_length(:secret, min: 12, count: :bytes)
    |> put_change(:secret, secret)
    |> put_change(:code, NimbleTOTP.verification_code(secret, period: 300))
  end
end
