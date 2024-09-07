defmodule NoraxCore.Accounts.AuthTokensFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoraxCore.Accounts.AuthTokens` context.
  """
  import NoraxCore.JsonWebTokenFixtures

  alias NoraxCore.Accounts.AuthTokens.AuthToken
  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc """
  Builds a fake `AuthToken`

    ## Examples

      iex> build_auth_token(user, opts)
      %AuthToken{field: value, ...}

  """
  def build_auth_token(%User{} = user, opts \\ []) do
    user
    |> build_jwt(opts)
    |> AuthToken.changeset()
    |> Ecto.Changeset.apply_action!(nil)
  end

  @doc """
  Inserts a fake `AuthToken`

    ## Examples

      iex> insert_auth_token(user, opts)
      %AuthToken{field: value, ...}

  """
  def insert_auth_token(%User{} = user, opts \\ []) do
    user
    |> build_jwt(opts)
    |> AuthToken.changeset()
    |> Repo.insert!()
    |> Repo.preload(:user)
  end
end
