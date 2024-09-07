defmodule NoraxCore.Accounts.Users.Services.VerifyUser do
  @moduledoc false
  use NoraxCore, :validation

  import Swoosh.Email

  alias NoraxCore.Accounts.Users.User
  alias NoraxCore.Mailer

  @doc false
  def call(%User{} = user) do
    code = NimbleTOTP.verification_code(user.otp_secret, period: 300)

    case send_verification(user, code) do
      {:ok, _email} ->
        user
        |> Map.put(:code, code)
        |> then(&{:ok, &1})

      {:error, _reason} ->
        user
        |> change()
        |> add_error(:code, "can't be delivered")
        |> then(&{:error, &1})
    end
  end

  defp send_verification(user, code) do
    email =
      new()
      |> to({user.first_name, user.email})
      |> from({"Norax", "contact@norax.io"})
      |> subject("Your verification code")
      |> text_body(confirm_account_instructions(user, code))

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  def confirm_account_instructions(user, code) do
    """

    ==============================

    Hi #{user.first_name},

    Please, access your app and enter the code below to confirm your account:

    #{code}

    If you didn't create an account with us, please ignore this.

    ==============================
    """
  end

  def reset_password_instructions(user, code) do
    """

    ==============================

    Hi #{user.first_name},

    Please, access your app and enter the code below to reset your password:

    #{code}

    If you didn't request this change, please ignore this.

    ==============================
    """
  end

  def update_email_instructions(user, code) do
    """

    ==============================

    Hi #{user.first_name},

    Please, access your app and enter the code below to change your email:

    #{code}

    If you didn't request this change, please ignore this.

    ==============================
    """
  end
end
