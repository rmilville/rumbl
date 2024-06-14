defmodule RumblWeb.WatchHTML do
  use RumblWeb, :html
  use Phoenix.Component

  embed_templates("watch_html/*")

  def watch_component(assigns) do
    ~H"""
    <div id="video" data-id={@video.id} data-player-id={player_id(@video)}>
    </div>
    """
  end

  defp player_id(video) do
    ~r{^.*(?:youtu\.be/|\w+/|embed/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(video.url)
    |> get_in(["id"])
  end
end
