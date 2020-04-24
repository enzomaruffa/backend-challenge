defmodule ReflectionsWeb.Router do
  use ReflectionsWeb, :router

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", ReflectionsWeb do
    pipe_through :browser
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ReflectionsWeb do
    pipe_through :api
    post "/users/sign_in", UserController, :sign_in
    post "/users/date_difference", UserController, :date_difference
    post "/userreflections/get_user_id", UserReflectionController, :fetch_user_email
    post "/userreflections/get_reflection_id", UserReflectionController, :fetch_reflection_id
    post "/userreflections/get_dates", UserReflectionController, :fetch_dates
  end

  scope "/api", ReflectionsWeb do
    pipe_through [:api, :api_auth]
    resources "/users", UserController, except: [:new, :edit]
    resources "/userreflections", UserReflectionController, except: [:new, :edit]
    post "/users/get_email", UserController, :fetch_user_email
  end

  # Plug function
  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(ReflectionsWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
      end
    end
end
