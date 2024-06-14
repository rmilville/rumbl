defmodule RumblWeb.UserHTML do
  @moduledoc """
  This module contains pages rendered by UserController.

  See the `user_html` directory for all templates available.
  """
  use RumblWeb, :html

  alias Rumbl.Accounts

  embed_templates("user_html/*")

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def render_user(user), do: %{id: user.id, username: user.name}

end
