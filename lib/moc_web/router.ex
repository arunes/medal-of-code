defmodule MocWeb.Router do
  use MocWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MocWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MocWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/leaderboard", LeaderboardController, :index
    get "/stats", StatsController, :index
    get "/medals", MedalController, :index
    get "/medals/:id", MedalController, :detail
    live "/contributors", ContributorLive
    get "/contributors/:id", ContributorController, :detail
  end

  scope "/admin", MocWeb do
    pipe_through :browser

    get "/", Admin.DashboardController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MocWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:moc, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MocWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
