defmodule RumblWeb.SessionController do
  use RumblWeb, :controller
  use Phoenix.Component

  alias Rumbl.Accounts

  def new(conn, _params) do
    render(conn, :new, form: to_form(%{}))
  end

  def create(conn, %{"username" => username, "password" => given_pass}) do
    with {:ok, user} <- Accounts.authenticate_by_username_and_pass(username, given_pass) do
      conn
      |> RumblWeb.Auth.login(user)
      |> put_flash(:info, "Welcome back!")
      |> redirect(to: ~p"/users")
    else
      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> redirect(to: ~p"/sessions/new")
    end
  end

  def delete(conn, _params) do
    conn
    |> RumblWeb.Auth.logout()
    |> redirect(to: ~p"/")
  end
end
