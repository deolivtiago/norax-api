defmodule NoraxCore.Accounts.UsersTest do
  use NoraxCore.DataCase, async: true

  import NoraxCore.Accounts.UsersFixtures

  alias Ecto.Changeset

  alias NoraxCore.Accounts.Users
  alias NoraxCore.Accounts.Users.User

  setup do
    {:ok, attrs: user_attrs()}
  end

  describe "list_users/0" do
    test "without users returns an empty list" do
      assert [] == Users.list_users()
    end

    test "with users returns all users" do
      user = insert_user()

      assert [user] == Users.list_users()
    end
  end

  describe "get_user/1 returns" do
    setup [:put_user]

    test "ok when the given id is found", %{user: user} do
      assert {:ok, user} == Users.get_user(id: user.id)
    end

    test "error when the given id is not found" do
      id = Ecto.UUID.generate()

      assert {:error, changeset} = Users.get_user(id: id)
      errors = errors_on(changeset.changes.user)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "not found")
    end

    test "ok when the given email is found", %{user: user} do
      assert {:ok, user} == Users.get_user(email: user.email)
    end

    test "error when the given email is not found" do
      assert {:error, changeset} = Users.get_user(email: "not.found@mail.com")
      errors = errors_on(changeset.changes.user)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "not found")
    end
  end

  describe "create_user/1 returns" do
    test "ok when the user attributes are valid", %{attrs: attrs} do
      assert {:ok, %User{} = user} = Users.create_user(attrs)

      assert user.first_name == attrs.first_name
      assert user.last_name == attrs.last_name
      assert user.email == attrs.email
      assert user.role == attrs.role
      assert Argon2.verify_pass(attrs.password, user.password)
    end

    test "error when the user attributes are invalid" do
      attrs = %{email: "???", first_name: nil, password: "?", role: "invalid"}

      assert {:error, changeset} = Users.create_user(attrs)
      errors = errors_on(changeset.changes.user)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.first_name, "can't be blank")
      assert Enum.member?(errors.email, "has invalid format")
      assert Enum.member?(errors.password, "should be at least 6 character(s)")
      assert Enum.member?(errors.role, "is invalid")
    end

    test "error when the user email already exists", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, insert_user().email)

      assert {:error, changeset} = Users.create_user(attrs)
      errors = errors_on(changeset.changes.user)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has already been taken")
    end
  end

  describe "update_user/2 returns" do
    setup [:put_user]

    test "ok when the user attributes are valid", %{user: %{id: id} = user, attrs: attrs} do
      assert {:ok, %User{id: ^id} = user} = Users.update_user(user, attrs)

      assert attrs.id != user.id
      assert attrs.first_name == user.first_name
      assert attrs.last_name == user.last_name
      assert attrs.role == user.role
      assert Argon2.verify_pass(attrs.password, user.password)
    end

    test "error when the user attributes are invalid", %{user: user} do
      invalid_attrs = %{email: "?@?", first_name: "", password: "?", role: 0}

      assert {:error, changeset} = Users.update_user(user, invalid_attrs)
      errors = errors_on(changeset.changes.user)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.first_name, "can't be blank")
      assert Enum.member?(errors.email, "has invalid format")
      assert Enum.member?(errors.password, "should be at least 6 character(s)")
      assert Enum.member?(errors.role, "is invalid")
    end
  end

  describe "delete_user/1 returns" do
    setup [:put_user]

    test "ok when the user is deleted", %{user: user} do
      assert {:ok, %User{}} = Users.delete_user(user)

      assert {:error, changeset} = Users.delete_user(user)
      errors = errors_on(changeset.changes.user)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "not found")
    end
  end

  describe "authenticate/1 returns" do
    test "ok when user credentials are valid", %{attrs: attrs} do
      user = insert_user(attrs)

      assert {:ok, user} == Users.authenticate_user(attrs)
    end

    test "error when the given email is invalid", %{attrs: attrs} do
      credentials = %{email: "invalid@mail.com", password: insert_user(attrs).password}

      assert {:error, changeset} = Users.authenticate_user(credentials)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.credentials, "are invalid")
    end

    test "error when the given password is invalid", %{attrs: attrs} do
      credentials = %{email: insert_user(attrs).email, password: "invalid.password"}

      assert {:error, changeset} = Users.authenticate_user(credentials)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.credentials, "are invalid")
    end
  end

  defp put_user(_) do
    {:ok, user: insert_user(%{role: :user})}
  end
end
