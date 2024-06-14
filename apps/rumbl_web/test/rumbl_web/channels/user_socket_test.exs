defmodule RumblWeb.Channels.UserSocketTest do
  use RumblWeb.ChannelCase, async: true
  alias RumblWeb.UserSocket

  test "socket authentication with valid token" do
    token = Phoenix.Token.sign(RumblWeb.Endpoint, "user socket", "good")

    assert {:ok, socket} = connect(UserSocket, %{"token" => token})
    assert socket.assigns.user_id == "good"
  end

  test "socket authentication with invalid token" do
    assert :error = connect(UserSocket, %{"token" => "bad"})
    assert :error = connect(UserSocket, %{})
  end
end
