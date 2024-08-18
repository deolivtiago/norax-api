defmodule NoraxCore.Accounts.OtpCodesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoraxCore.Accounts.OtpCodes` context.
  """

  alias NoraxCore.Accounts.OtpCodes.OtpCode
  alias NoraxCore.Repo

  @doc """
  Generate fake pin code attrs

    ## Examples

      iex> otp_code_attrs(%{field: value})
      %{field: value, ...}

  """
  def otp_code_attrs(attrs \\ %{}) do
    Map.new()
    |> Map.put(:id, Faker.UUID.v4())
    |> Map.put(:email, Faker.Internet.email())
    |> Map.put(:code, Integer.to_string(Enum.random(100_000..999_999)))
    |> Map.put(:expires_at, DateTime.add(DateTime.utc_now(:second), Enum.random(-9..9), :minute))
    |> Map.put(:inserted_at, DateTime.add(DateTime.utc_now(:second), Enum.random(-90..-1), :day))
    |> Map.put(:updated_at, DateTime.add(DateTime.utc_now(:second), Enum.random(-90..-1), :day))
    |> Map.merge(attrs)
  end

  @doc """
  Inserts a fake pin code

    ## Examples

      iex> insert_otp_code(%{field: value})
      %OtpCode{field: value, ...}

  """
  def insert_otp_code(attrs \\ %{}) do
    attrs
    |> otp_code_attrs()
    |> OtpCode.changeset()
    |> Repo.insert!()
  end
end
