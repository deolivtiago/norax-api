defmodule NoraxCore.Accounts.Users.Services.CreateUser do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(params) when is_map(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
