defmodule NoraxCore.Accounts.Users.Services.ListUsers do
  @moduledoc false

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call, do: Repo.all(User)
end
