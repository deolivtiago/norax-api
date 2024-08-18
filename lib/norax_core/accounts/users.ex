defmodule NoraxCore.Accounts.Users do
  @moduledoc """
  The `Accounts.Users` context.
  """

  alias NoraxCore.Accounts.Users.User

  @doc """
  Lists all users

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  defdelegate list_users, to: User.List, as: :call

  @doc """
  Gets an user

  ## Examples

      iex> get_user(id)
      {:ok, %User{}}

      iex> get_user(bad_id)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate get_user(id), to: User.Get, as: :call

  @doc """
  Creates an user

  ## Examples

      iex> create_user(attrs)
      {:ok, %User{}}

      iex> create_user(bad_attrs)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate create_user(attrs), to: User.Create, as: :call

  @doc """
  Updates an user

  ## Examples

      iex> update_user(user, params)
      {:ok, %User{}}

      iex> update_user(user, bad_attrs)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate update_user(user, attrs), to: User.Update, as: :call

  @doc """
  Deletes an user

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(bad_user)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate delete_user(user), to: User.Delete, as: :call

  @doc """
  Authenticates an user

  ## Examples

      iex> authenticate_user(attrs)
      {:ok, %User{}}

      iex> authenticate_user(bad_attrs)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate authenticate_user(attrs), to: User.Authenticate, as: :call
end
