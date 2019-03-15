defmodule NotebookWeb.Router do
  use NotebookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {NotebookWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NotebookWeb do
    pipe_through :browser

    live "/page", PageLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", NotebookWeb do
  #   pipe_through :api
  # end
end
