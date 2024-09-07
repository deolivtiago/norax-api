defmodule NoraxCore.Accounts.AuthTokens.AuthToken.Revoke do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.AuthTokens.AuthToken
  alias NoraxCore.Repo

  @doc false
  def call(%AuthToken{} = auth_token) do
    with {:ok, auth_token} <- Repo.delete(auth_token) do
      auth_token
      |> Repo.preload(:user)
      |> then(&{:ok, &1})
    end
  end
end
