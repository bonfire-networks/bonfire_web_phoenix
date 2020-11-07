defmodule CommonsPub.WebPhoenix.Router do
  use CommonsPub.WebPhoenix, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CommonsPub.WebPhoenix.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :browser
    forward "/", Application.get_env(:cpub_web_phoenix, :routes_module)
  end

  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CommonsPub.WebPhoenix.Telemetry
    end
  end
end
