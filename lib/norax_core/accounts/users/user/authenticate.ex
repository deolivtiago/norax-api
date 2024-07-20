defmodule NoraxCore.Accounts.Users.User.Authenticate do
  @moduledoc false
  use NoraxCore, :validation

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc false
  def call(params) when is_map(params) do
    %{email: email, password: password} = params

    user = Repo.get_by(User, email: email)

    if valid_password?(user, password) do
      {:ok, user}
    else
      Map.new()
      |> Map.put(:credentials, type: :map)
      |> cast(%{credentials: params})
      |> add_error(:credentials, "are invalid")
      |> then(&{:error, &1})
    end
  end

  defp valid_password?(%User{} = user, password) when is_binary(password) do
    Argon2.verify_pass(password, user.password)
  end

  defp valid_password?(nil, _password), do: Argon2.no_user_verify()
end
