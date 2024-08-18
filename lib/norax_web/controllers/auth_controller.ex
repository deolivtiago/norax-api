defmodule NoraxWeb.AuthController do
  @moduledoc false
  use NoraxWeb, :controller

  alias NoraxCore.Accounts.OtpCodes
  alias NoraxCore.Accounts.Users
  alias NoraxWeb.Controllers.AuthParams

  action_fallback NoraxWeb.FallbackController

  @doc false
  def signup(conn, params) do
    with {:ok, %{code: code, user: user_data}} <- AuthParams.validate(:signup, params),
         {:ok, otp_code} <- OtpCodes.verify_otp_code(code, user_data.email),
         {:ok, user} <- Users.create_user(user_data),
         {:ok, _otp_code} <- OtpCodes.revoke_otp_code(otp_code) do
      conn
      |> put_view(NoraxWeb.UserJSON)
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc false
  def signin(conn, params) do
    with {:ok, %{credentials: user_credentials}} <- AuthParams.validate(:signin, params),
         {:ok, user} <- Users.authenticate_user(user_credentials) do
      conn
      |> put_view(NoraxWeb.UserJSON)
      |> render(:show, user: user)
    end
  end

  @doc false
  def send_code(conn, params) do
    with {:ok, %{email: user_email}} <- AuthParams.validate(:email, params),
         {:ok, otp_code} <- OtpCodes.create_otp_code(%{email: user_email}) do
      render(conn, :show, otp_code: otp_code)
    end
  end

  @doc false
  def revoke_code(conn, params) do
    with {:ok, %{email: user_email}} <- AuthParams.validate(:email, params) do
      OtpCodes.list_otp_codes(email: user_email) |> Enum.each(&OtpCodes.revoke_otp_code/1)

      send_resp(conn, :no_content, "")
    end
  end
end
