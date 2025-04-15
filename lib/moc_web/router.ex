defmodule MocWeb.Router do
  use MocWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MocWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :check_setup
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  def check_setup(conn, _opts) do
    Moc.Runtime.Setup.get_status() |> handle_setup_status(conn)
  end

  # don't show init again if admin is setup
  def handle_setup_status(status, %{request_path: "/admin/init"} = conn)
      when status != :no_admin do
    redirect(conn, to: "/admin") |> halt()
  end

  # if no admin, and already on the init page
  def handle_setup_status(:no_admin, %{request_path: "/admin/init"} = conn), do: conn

  def handle_setup_status(:no_admin, conn) do
    redirect(conn, to: "/admin/init") |> halt()
  end

  def handle_setup_status(_status, conn), do: conn

  scope "/", MocWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/setup-incomplete", HomeController, :setup_incomplete
    get "/leaderboard", LeaderboardController, :index
    get "/stats", StatsController, :index
    get "/medals", MedalController, :index
    get "/medals/:id", MedalController, :detail
    live "/contributors", ContributorLive
    get "/contributors/:id", ContributorController, :detail
  end

  scope "/admin", MocWeb do
    pipe_through :browser

    live "/", Admin.OrganizationsLive
    live "/init", Admin.InitLive
    live "/settings", Admin.SettingsLive
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
