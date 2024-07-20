defmodule NoraxCore.Accounts.Users.User.Get do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(params) do
    with {:error, changeset} <- get_by(params) do
      Map.new()
      |> Map.put(:user, type: :map)
      |> cast(%{user: changeset})
      |> then(&{:error, &1})
    end
  end

  defp get_by([{key, _value} | []] = params) when is_list(params) do
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
