defmodule NoraxCore.Accounts.AuthTokensTest do
  use NoraxCore.DataCase, async: true

  import NoraxCore.Accounts.UsersFixtures
  import NoraxCore.Accounts.AuthTokensFixtures

  alias Ecto.Changeset
  alias NoraxCore.Accounts.AuthTokens
  alias NoraxCore.Accounts.AuthTokens.AuthToken
  alias NoraxCore.Accounts.Users.User

  setup do
    {:ok, user: insert_user(%{code: nil})}
  end

  describe "verify_auth_token/2 returns" do
    test "ok when access token is valid", %{user: user} do
      auth_token = insert_auth_token(user, typ: :access)

      assert {:ok, auth_token} == AuthTokens.verify_auth_token(auth_token.token, :access)
    end

    test "ok when refresh token is valid", %{user: user} do
      auth_token = insert_auth_token(user, typ: :refresh)

      assert {:ok, auth_token} == AuthTokens.verify_auth_token(auth_token.token, :refresh)
    end

    test "error when token is invalid" do
      assert {:error, changeset} = AuthTokens.verify_auth_token("invalid_token", :access)
      errors = errors_on(changeset)

      assert Enum.member?(errors.token, "is invalid")
    end

    test "error when access token has a different type", %{user: user} do
      auth_token = insert_auth_token(user, typ: :refresh)

      assert {:error, changeset} = AuthTokens.verify_auth_token(auth_token.token, :access)
      errors = errors_on(changeset)

      assert Enum.member?(errors.token, "is invalid")
    end

    test "error when refresh token has a different type", %{user: user} do
      auth_token = insert_auth_token(user, typ: :access)

      assert {:error, changeset} = AuthTokens.verify_auth_token(auth_token.token, :refresh)
      errors = errors_on(changeset)

      assert Enum.member?(errors.token, "is invalid")
    end
  end

  describe "create_auth_token/2 returns" do
    test "ok when access token is valid", %{user: user} do
      assert {:ok, auth_token} = AuthTokens.create_auth_token(user, :access)

      assert auth_token.user == user
      assert auth_token.type == :access
      assert auth_token.user_id == user.id
      assert DateTime.to_date(auth_token.expires_at) == Date.add(Date.utc_today(), 2)
    end

    test "ok when refresh token is valid", %{user: user} do
      assert {:ok, auth_token} = AuthTokens.create_auth_token(user, :refresh)

      assert auth_token.user == user
      assert auth_token.type == :refresh
      assert auth_token.user_id == user.id
      assert DateTime.to_date(auth_token.expires_at) == Date.add(Date.utc_today(), 14)
    end

    test "error when user is invalid" do
      assert {:error, changeset} = AuthTokens.create_auth_token(%User{}, :access)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "can't be signed")
    end

    test "error when type is invalid", %{user: user} do
      assert {:error, changeset} = AuthTokens.create_auth_token(user, :invalid_type)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "can't be signed")
    end
  end

  describe "revoke_user_token/1" do
    test "returns ok auth token is revoked", %{user: user} do
      auth_token = insert_auth_token(user, typ: :access)

      assert {:ok, %AuthToken{user: ^user}} = AuthTokens.revoke_auth_token(auth_token)
    end
  end
end
