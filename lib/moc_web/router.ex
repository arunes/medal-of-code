defmodule MocWeb.Router do
  use MocWeb, :router

  import MocWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MocWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :redirect_if_setup_incomplete
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_current_user
  end

  scope "/", MocWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [
        {MocWeb.UserAuth, :ensure_authenticated}
      ] do
      live "/", HomeLive.Index
      live "/contributors", ContributorLive.Index
      live "/contributors/:id", ContributorLive.Show
      live "/contributors/:id/history", ContributorLive.Show
      live "/medals", MedalLive.Index
      live "/medals/:id", MedalLive.Show
      live "/leaderboard", LeaderboardLive.Index
      live "/privacy", PrivacyLive.Index
      live "/stats", StatsLive.Index
    end
  end

  scope "/", MocWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{MocWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/init", InitLive
      live "/users/log_in", UserLoginLive, :new
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", MocWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", MocWeb do
    pipe_through [:browser, :require_admin_user]

    live_session :require_admin_user,
      on_mount: [{MocWeb.UserAuth, :ensure_is_admin}] do
      live "/admin", AdminLive.Index
      live "/admin/organizations", AdminLive.Organization.Index
      live "/admin/organizations/new", AdminLive.Organization.Create
      live "/admin/organizations/:organization_id", AdminLive.Organization.Projects

      live "/admin/organizations/:organization_id/:project_id",
           AdminLive.Organization.Repositories

      live "/admin/settings", AdminLive.Settings
      live "/admin/users", AdminLive.Users
    end
  end

  scope "/api", MocWeb do
    pipe_through [:api, :require_authenticated_user]
    get "/contributors/activity", ContributorController, :all_activity
    get "/contributors/:id/activity", ContributorController, :activity
  end

  def redirect_if_setup_incomplete(%{request_path: path} = conn, _opts) do
    status = Moc.Instance.get_status()

    cond do
      # redirect to init if no admin and on any other page
      status == :no_admin && path != "/init" -> redirect(conn, to: "/init") |> halt()
      # don't show init again if admin is setup
      status != :no_admin && path == "/init" -> redirect(conn, to: "/") |> halt()
      true -> conn
    end
  end

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
