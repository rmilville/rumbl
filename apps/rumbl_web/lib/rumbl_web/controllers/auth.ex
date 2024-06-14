defmodule RumblWeb.Auth do
  @moduledoc """
  This module contains controllers for authentication and authorization.
  """

  import Plug.Conn
  import Phoenix.Controller
  use RumblWeb, :verified_routes

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] -> conn

      user = user_id && Rumbl.Accounts.get_user(user_id) ->
        put_current_user(conn, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end

  def logout(conn), do: configure_session(conn, drop: true)

  def authenticate_user(conn, _opts \\ []) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Login required")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
