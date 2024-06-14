defmodule RumblWeb.Channels.VideoChannelTest do
  use RumblWeb.ChannelCase
  import RumblWeb.TestHelpers

  setup do
    user = insert_user(name: "tester")
    video = insert_video(user, title: "test video")
    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)

    {:ok, socket} = connect(RumblWeb.UserSocket, %{"token" => token})
    {:ok, socket: socket, user: user, video: video}
  end

  test "join replies with video annotations", %{socket: socket, video: vid, user: user} do
    for body <- ~w(one two) do
      Rumbl.Multimedia.annotate_video(user, vid.id, %{body: body, at: 0})
    end
    {:ok, reply, socket} = subscribe_and_join(socket, "videos:#{vid.id}", %{})

    assert socket.assigns.user_id == user.id
    assert %{annotations: [%{body: "one"}, %{body: "two"}]} = reply
  end

  test "inserting new annotations", %{socket: socket, video: vid} do
    {:ok, _, socket} = subscribe_and_join(socket, "videos:#{vid.id}", %{})
    ref = push(socket, "new_annotation", %{body: "the body", at: 0})

    assert_reply(ref, :ok, %{})

    assert_broadcast("new_annotation", %{})
  end

#  test "new annotations triggers InfoSys", %{socket: socket, video: vid} do
#    insert_user(
#      username: "worlfram",
#      password: "supersecret"
#    )
#
#    {:ok, _, socket} = subscribe_and_join(socket, "videos:#{vid.id}", %{})
#
 #   ref = push(socket, "new_annotation", %{body: "what is elixir", at: 123})
#
 #   assert_reply(ref, :ok, %{})
#
 #   assert_broadcast("new_annotation", %{body: "what is elixir", at: 123})
#
 #   text = """
#1 | noun | a sweet flavored liquid (usually containing a small amount of alcohol) used in compounding medicines to be taken by mouth in order to mask an unpleasant taste
#2 | noun | hypothetical substance that the alchemists believed to be capable of changing base metals into gold
#3 | noun | a substance believed to cure all ills\
#"""
#
#    assert_broadcast("new_annotation", %{body: text}, at: 123)
#  end

end
