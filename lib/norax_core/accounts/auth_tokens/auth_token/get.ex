defmodule NoraxCore.Accounts.AuthTokens.AuthToken.Get do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.AuthTokens.AuthToken
  alias NoraxCore.Repo

  @doc false
  def call(params) when is_non_struct_map(params) do
    params
    |> get_by()
    |> handle_result()
  end

  defp get_by(params) do
    field = params |> Map.keys() |> List.first()

    case Repo.get_by(AuthToken, params) do
      %AuthToken{} = auth_token ->
        auth_token
        |> Repo.preload(:user)
        |> then(&{:ok, &1})

      nil ->
        AuthToken.changeset()
        |> change(params)
        |> add_error(field, "not found")
        |> then(&{:error, &1})
    end
  end

  defp handle_result({:ok, auth_token}) do
    Map.new()
    |> Map.put(:auth_token, auth_token)
    |> cast_params()
    |> then(&{:ok, &1})
  end

  defp handle_result({:error, changeset}) do
    Map.new()
    |> Map.put(:auth_token, changeset)
    |> cast_params()
    |> then(&{:error, &1})
  end
end
