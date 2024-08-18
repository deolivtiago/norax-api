defmodule NoraxCore.Accounts.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoraxCore.Accounts.Users` context.
  """
  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Repo

  @doc """
  Generate fake user attrs

    ## Examples

      iex> user_attrs(%{field: value})
      %{field: value, ...}

  """
  def user_attrs(attrs \\ %{}) do
    Map.new()
    |> Map.put(:id, Faker.UUID.v4())
    |> Map.put(:first_name, Faker.Person.first_name())
    |> Map.put(:last_name, Faker.Person.last_name())
    |> Map.put(:email, Faker.Internet.email())
    |> Map.put(:password, "P455w0rd?")
    |> Map.put(:avatar_url, Faker.Internet.image_url())
    |> Map.put(:role, Enum.random(~w(user admin)a))
    |> Map.put(:inserted_at, DateTime.add(DateTime.utc_now(:second), Enum.random(-90..-1), :day))
    |> Map.put(:updated_at, DateTime.add(DateTime.utc_now(:second), Enum.random(-90..-1), :day))
    |> Map.merge(attrs)
  end

  @doc """
  Builds a fake user

    ## Examples

      iex> build_user(%{field: value})
      %User{field: value, ...}

  """
  def build_user(attrs \\ %{}) do
    attrs
    |> user_attrs()
    |> User.changeset()
    |> Ecto.Changeset.apply_action!(nil)
  end

  @doc """
  Inserts a fake user

    ## Examples

      iex> insert_user(%{field: value})
      %User{field: value, ...}

  """
  def insert_user(attrs \\ %{}) do
    attrs
    |> user_attrs()
    |> User.changeset()
    |> Repo.insert!()
  end
end
