defmodule NotebookWeb.PageController do
  use NotebookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
