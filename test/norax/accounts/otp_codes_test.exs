defmodule NoraxCore.Accounts.OtpCodesTest do
  use NoraxCore.DataCase, async: true

  import NoraxCore.Accounts.OtpCodesFixtures

  alias Ecto.Changeset
  alias NoraxCore.Accounts.OtpCodes

  setup do
    {:ok, attrs: otp_code_attrs()}
  end

  describe "create_otp_code/1 returns" do
    test "ok when email is valid", %{attrs: attrs} do
      assert {:ok, otp_code} = OtpCodes.create_otp_code(attrs)

      assert otp_code.email == attrs.email
    end

    test "error when email is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "")

      assert {:error, changeset} = OtpCodes.create_otp_code(attrs)
      errors = errors_on(changeset.changes.otp_code)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "can't be blank")
    end

    test "when email has invalid format", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "email.invalid")

      assert {:error, changeset} = OtpCodes.create_otp_code(attrs)
      errors = errors_on(changeset.changes.otp_code)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has invalid format")
    end

    test "when email is too short", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "@@")

      assert {:error, changeset} = OtpCodes.create_otp_code(attrs)
      errors = errors_on(changeset.changes.otp_code)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "should be at least 3 character(s)")
    end
  end

  describe "verify/2 returns" do
    setup [:put_otp_code]

    test "ok when pin code is valid", %{otp_code: otp_code} do
      code = NimbleTOTP.verification_code(otp_code.secret, period: 300)

      assert {:ok, otp_code} == OtpCodes.verify_otp_code(code, otp_code.email)
    end

    test "error when pin code has invalid code", %{otp_code: otp_code} do
      assert {:error, changeset} = OtpCodes.verify_otp_code("invalid.code", otp_code.email)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.code, "is invalid")
    end

    test "error when pin code has invalid email", %{otp_code: otp_code} do
      code = NimbleTOTP.verification_code(otp_code.secret, period: 300)

      assert {:error, changeset} = OtpCodes.verify_otp_code(code, "invalid@mail")

      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.code, "is invalid")
    end
  end

  describe "revoke/1 returns" do
    setup [:put_otp_code]

    test "ok when pin code is revoked", %{otp_code: %{code: code} = otp_code} do
      assert {:ok, %{code: ^code}} = OtpCodes.revoke_otp_code(otp_code)
    end
  end

  defp put_otp_code(%{attrs: attrs}) do
    attrs
    |> insert_otp_code()
    |> then(&{:ok, otp_code: &1})
  end
end
