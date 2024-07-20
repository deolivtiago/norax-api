defmodule NoraxCore.Accounts.Users.Services.UpdateUser do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(%User{} = user, params) when is_map(params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end
end
