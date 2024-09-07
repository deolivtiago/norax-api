defmodule NoraxCore.Accounts.AuthTokens.AuthToken.Verify do
  @moduledoc false
  use NoraxCore, :validation

  import Ecto.Query, only: [from: 2]

  alias NoraxCore.Accounts.AuthTokens.AuthToken
  alias NoraxCore.JsonWebToken
  alias NoraxCore.Repo

  @doc false
  def call(token, token_type) when is_atom(token_type) do
    with {:ok, %{claims: %{typ: ^token_type}}} <- JsonWebToken.from_token(token),
         %AuthToken{} = auth_token <- Repo.get_by(query(), token: token, type: token_type) do
      auth_token
      |> Repo.preload(:user)
      |> then(&{:ok, &1})
    else
      _error ->
        %AuthToken{}
        |> change(%{token: token})
        |> add_error(:token, "is invalid")
        |> then(&{:error, &1})
    end
  end

  defp query do
    from ut in AuthToken,
      where: ut.expires_at > ^DateTime.utc_now(:second)
  end
end
