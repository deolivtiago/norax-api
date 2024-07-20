defmodule NoraxCore.Accounts.Users.User.Delete do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @opts [stale_error_field: :id, stale_error_message: "not found"]

  @doc false
  def call(%User{} = user) do
    with {:error, changeset} <- Repo.delete(user, @opts) do
      Map.new()
      |> Map.put(:user, type: :map)
      |> cast(%{user: changeset})
      |> then(&{:error, &1})
    end
  end
end
