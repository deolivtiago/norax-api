defmodule NoraxCore.Accounts.Users.Services.DeleteUser do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @opts [stale_error_field: :id, stale_error_message: "not found"]

  @doc false
  def call(%User{} = user), do: Repo.delete(user, @opts)
end
