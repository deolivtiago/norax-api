defmodule NoraxCore.Accounts.Users do
  @moduledoc """
  The `Accounts.Users` context.
  """

  alias NoraxCore.Accounts.Users.Services

  @doc """
  Lists all users

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  defdelegate list_users, to: Services.ListUsers, as: :call

  @doc """
  Gets an user

  ## Examples

      iex> get_user(field, value)
      {:ok, %User{}}

      iex> get_user(field, bad_value)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate get_user(field, value, opts \\ []), to: Services.GetUser, as: :call

  @doc """
  Creates an user

  ## Examples

      iex> create_user(attrs)
      {:ok, %User{}}

      iex> create_user(bad_attrs)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate create_user(attrs), to: Services.CreateUser, as: :call

  @doc """
  Updates an user

  ## Examples

      iex> update_user(user, attrs)
      {:ok, %User{}}

      iex> update_user(user, bad_attrs)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate update_user(user, attrs), to: Services.UpdateUser, as: :call

  @doc """
  Deletes an user

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(bad_user)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate delete_user(user), to: Services.DeleteUser, as: :call

  @doc """
  Authenticates an user

  ## Examples

      iex> authenticate_user(attrs)
      {:ok, %User{}}

      iex> authenticate_user(bad_attrs)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate authenticate_user(attrs), to: Services.AuthenticateUser, as: :call

  @doc """
  Verifies an user

  ## Examples

      iex> verify_user(user, code)
      {:ok, %User{}}

      iex> verify_user(user, bad_code)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate verify_user(user, code), to: Services.VerifyUser, as: :call
end
