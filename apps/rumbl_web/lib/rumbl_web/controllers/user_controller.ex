defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  use Phoenix.Component

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  plug(:authenticate_user when action in [:index, :show])

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, :show, user: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_registration(%User{}, %{})
    form = to_form(changeset)
    render(conn, :new, form: form)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do
      conn
      |> RumblWeb.Auth.login(user)
      |> put_flash(:info, "#{user.name} created!")
      |> redirect(to: ~p"/users")
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        form = to_form(changeset)
        render(conn, :new, form: form)
    end
  end
end
