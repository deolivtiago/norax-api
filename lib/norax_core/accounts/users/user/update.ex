defmodule NoraxCore.Accounts.Users.User.Update do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(%User{} = user, params) when is_map(params) do
    changeset = User.changeset(user, params)

    with {:error, changeset} <- Repo.update(changeset) do
      Map.new()
      |> Map.put(:user, type: :map)
      |> cast(%{user: changeset})
      |> then(&{:error, &1})
    end
  end
end
