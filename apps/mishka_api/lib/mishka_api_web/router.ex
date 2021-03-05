defmodule MishkaApiWeb.Router do
  use MishkaApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MishkaApiWeb do
    pipe_through :api

  end

  scope "/api/auth/v1", MishkaApiWeb do
    pipe_through :api
    post "/register", AuthController, :rgister
    post "/login", AuthController, :login
    post "/refresh-token", AuthController, :refresh_token
    post "/change-password", AuthController, :change_password
    post "/user-tokens", AuthController, :user_tokens
    post "/get-token-expire-time", AuthController, :get_token_expire_time
    post "/reset-password", AuthController, :reset_password
    post "/delete-token", AuthController, :delete_token
    post "/delete-tokens", AuthController, :delete_tokens
    post "/edit-profile", AuthController, :edit_profile
    post "/deactive-account", AuthController, :deactive_account
    post "/deactive-account-by-email-link", AuthController, :deactive_account_by_email_link
    post "/verify-email", AuthController, :verify_email
    post "/verify-email-by-email-link", AuthController, :verify_email_by_email_link
    post "/delete-tokens-by-email-link", AuthController, :delete_tokens_by_email_link
  end


  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MishkaApiWeb.Telemetry
    end
  end
end
