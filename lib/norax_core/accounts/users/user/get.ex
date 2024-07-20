defmodule NoraxCore.Accounts.Users.User.Get do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(params) when is_list(params) do
    with {:error, changeset} <- get_by(params) do
      Map.new()
      |> Map.put(:user, type: :map)
      |> cast(%{user: changeset})
      |> then(&{:error, &1})
    end
  end

  defp get_by([{key, value} | [{:verified?, true} | []]]) when is_atom(key) do
    params = [{key, value}]

    with {:ok, %User{verified?: false} = user} <- get_by(params) do
      user
      |> User.changeset(%{})
      |> add_error(:email, "must be verified")
      |> then(&{:error, &1})
    end
  end

  defp get_by([{key, _value} | []] = params) when is_atom(key) do
    case Repo.get_by(User, params) do
      %User{} = user ->
        {:ok, user}

      nil ->
        User.changeset()
        |> change(params)
        |> add_error(key, "not found")
        |> then(&{:error, &1})
    end
  end
end
