defmodule NoraxWeb.AuthController do
  @moduledoc false
  use NoraxWeb, :controller

  alias NoraxWeb.AuthController.SendCodeHandler
  alias NoraxWeb.AuthController.SignInHandler
  alias NoraxWeb.AuthController.SignOutHandler
  alias NoraxWeb.AuthController.SignUpHandler
  alias NoraxWeb.AuthController.VerifyCodeHandler

  action_fallback NoraxWeb.FallbackController

  @doc false
  def signup(conn, params) do
    with {:ok, %{attrs: attrs}} <- SignUpHandler.validate_params(params),
         {:ok, user} <- SignUpHandler.create_user(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc false
  def signin(conn, params) do
    with {:ok, %{attrs: attrs}} <- SignInHandler.validate_params(params),
         {:ok, user} <- SignInHandler.authenticate_user(attrs),
         {:ok, auth} <- SignInHandler.generate_auth_tokens(user) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, auth: auth)
    end
  end

  @doc false
  def signout(conn, params) do
    with {:ok, %{auth: auth}} <- SignOutHandler.validate_params(params),
         {:ok, _auth} <- SignOutHandler.revoke_auth_tokens(auth) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc false
  def verify(conn, params) do
    with {:ok, %{email: email}} <- SendCodeHandler.validate_params(params),
         {:ok, user} <- SendCodeHandler.get_user(email),
         {:ok, user} <- SendCodeHandler.send_verification(user) do
      send_resp(conn, :ok, "#{user.code}")
    end
  end

  @doc false
  def confirm(conn, params) do
    with {:ok, %{email: email, code: code}} <- VerifyCodeHandler.validate_params(params),
         {:ok, user} <- VerifyCodeHandler.get_user(email),
         {:ok, user} <- VerifyCodeHandler.confirm_verification(user, code) do
      render(conn, :show, user: user)
    end
  end
end
