defmodule NoraxCore.Accounts.OtpCodes.OtpCodeTest do
  use NoraxCore.DataCase, async: true

  import NoraxCore.Accounts.OtpCodesFixtures

  alias Ecto.Changeset
  alias NoraxCore.Accounts.OtpCodes.OtpCode

  setup do
    {:ok, attrs: otp_code_attrs()}
  end

  describe "changeset/1 returns a valid changeset" do
    test "when email is valid", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, String.upcase(attrs.email))

      changeset = OtpCode.changeset(attrs)

      assert %Changeset{valid?: true} = changeset
      assert Changeset.get_field(changeset, :email) == String.downcase(attrs.email)
    end
  end

  describe "changeset/1 returns an invalid changeset" do
    test "when email is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "")

      changeset = OtpCode.changeset(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "can't be blank")
    end

    test "when email has invalid format", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "email.invalid")

      changeset = OtpCode.changeset(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has invalid format")
    end

    test "when email is too short", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "@@")

      changeset = OtpCode.changeset(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "should be at least 3 character(s)")
    end
  end
end
