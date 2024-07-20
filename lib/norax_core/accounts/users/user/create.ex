defmodule NoraxCore.Accounts.Users.User.Create do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(params) when is_map(params) do
    changeset = User.changeset(params)

    with {:error, changeset} <- Repo.insert(changeset) do
      Map.new()
      |> Map.put(:user, type: :map)
      |> cast(%{user: changeset})
      |> then(&{:error, &1})
    end
  end
end
