defmodule NoraxCore.Accounts.AuthTokens.AuthToken.Create do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.AuthTokens.AuthToken
  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.JsonWebToken
  alias NoraxCore.Repo

  @doc false
  def call(%User{id: id}, token_type) when is_atom(token_type) do
    changeset = changeset(id, token_type)

    with {:ok, auth_token} <- Repo.insert(changeset) do
      auth_token
      |> Repo.preload(:user)
      |> then(&{:ok, &1})
    end
  end

  defp changeset(sub, typ) do
    payload =
      Map.new()
      |> Map.put(:sub, sub)
      |> Map.put(:typ, typ)

    case JsonWebToken.from_payload(payload) do
      {:ok, jwt} ->
        AuthToken.changeset(jwt)

      {:error, _changeset} ->
        %AuthToken{}
        |> change(%{type: typ, user_id: sub})
        |> add_error(:token, "can't be signed")
    end
  end
end
