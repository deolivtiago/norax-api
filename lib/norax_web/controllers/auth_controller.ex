defmodule NoraxWeb.AuthController do
  @moduledoc false
  use NoraxWeb, :controller

  alias NoraxWeb.AuthController.Confirm
  alias NoraxWeb.AuthController.SignIn
  alias NoraxWeb.AuthController.SignOut
  alias NoraxWeb.AuthController.SignUp
  alias NoraxWeb.AuthController.Verify

  action_fallback NoraxWeb.FallbackController

  @doc false
  def signup(conn, params) do
    with {:ok, auth} <- SignUp.handle(params) do
      conn
      |> put_status(:created)
      |> render(:show, auth: auth)
    end
  end

  @doc false
  def signin(conn, params) do
    with {:ok, auth} <- SignIn.handle(params) do
      conn
      |> put_status(:ok)
      |> render(:show, auth: auth)
    end
  end

  @doc false
  def signout(conn, params) do
    with {:ok, _auth} <- SignOut.handle(params) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc false
  def verify(conn, params) do
    with {:ok, user} <- Verify.handle(params) do
      send_resp(conn, :ok, "#{user.code}")
    end
  end

  @doc false
  def confirm(conn, params) do
    with {:ok, user} <- Confirm.handle(params) do
      render(conn, :show, user: user)
    end
  end
end
