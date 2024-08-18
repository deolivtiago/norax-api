defmodule NoraxWeb.UserController do
  @moduledoc false
  use NoraxWeb, :controller

  alias NoraxCore.Accounts.Users
  alias NoraxWeb.Controllers.UserParams

  action_fallback NoraxWeb.FallbackController

  @doc false
  def index(conn, _params) do
    users = Users.list_users()

    render(conn, :index, users: users)
  end

  @doc false
  def create(conn, params) do
    with {:ok, %{user: user_data}} <- UserParams.validate(:create, params),
         {:ok, user} <- Users.create_user(user_data) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc false
  def show(conn, params) do
    with {:ok, %{id: user_id}} <- UserParams.validate(:show, params),
         {:ok, user} <- Users.get_user(id: user_id) do
      render(conn, :show, user: user)
    end
  end

  @doc false
  def update(conn, params) do
    with {:ok, %{id: user_id, user: user_data}} <- UserParams.validate(:update, params),
         {:ok, user} <- Users.get_user(id: user_id),
         {:ok, user} <- Users.update_user(user, user_data) do
      render(conn, :show, user: user)
    end
  end

  @doc false
  def delete(conn, params) do
    with {:ok, %{id: user_id}} <- UserParams.validate(:delete, params),
         {:ok, user} <- Users.get_user(id: user_id),
         {:ok, _user} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
