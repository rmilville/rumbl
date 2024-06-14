defmodule RumblWeb.AnnotationHTML do
  use RumblWeb, :html
  alias RumblWeb.UserHTML

  def render_annotation(%{annotation: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: UserHTML.render_user(annotation.user)
    }
  end
end
