defmodule ReflectionsWeb.PageController do
  use ReflectionsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
