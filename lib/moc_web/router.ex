defmodule MocWeb.Router do
  use MocWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MocWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :check_instance_status
  end

  scope "/", MocWeb do
    pipe_through :browser

    live "/", HomeLive.Index
    live "/init", HomeLive.Init
    live "/contributors", ContributorLive.Index
    live "/contributors/:id", ContributorLive.Show
    live "/medals", MedalLive.Index
    live "/medals/:id", MedalLive.Show
    live "/leaderboard", LeaderboardLive.Index
    live "/leaderboard/:date", LeaderboardLive.Show
    live "/privacy", PrivacyLive.Index
    live "/stats", StatsLive.Index
  end

  scope "/admin", MocWeb do
    pipe_through :browser
  end

  def check_instance_status(conn, _opts) do
    Moc.Instance.get_status() |> handle_setup_status(conn)
  end

  # don't show init again if admin is setup
  def handle_setup_status(status, %{request_path: "/init"} = conn)
      when status != :no_admin do
    redirect(conn, to: "/") |> halt()
  end

  # do nothing, if no admin, and already on the init page
  def handle_setup_status(:no_admin, %{request_path: "/init"} = conn), do: conn

  # redirect to init if no admin and on any other page
  def handle_setup_status(:no_admin, conn) do
    redirect(conn, to: "/init") |> halt()
  end

  def handle_setup_status(_status, conn), do: conn

  # Enable LiveDashboard in development
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
    end
  end
end
