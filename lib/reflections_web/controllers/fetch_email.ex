defmodule ReflectionsWeb.UserController do
  use ReflectionsWeb, :controller

  alias Reflections.Auth
  alias Reflections.Auth.User

  action_fallback ReflectionsWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> put_session(:current_user_id, user.id)
        |> put_view(ReflectionsWeb.UserView)
        |> render("sign_in.json", user: user)
    
      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> delete_session(:current_user_id)
        |> put_view(ReflectionsWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  def fetch_user_email(conn, %{"email" => email}) do
    user = Auth.fetch_email(email)
    render(conn, "show.json", user: user)
  end

  def date_difference(conn, %{"date1" => date1, "date2" => date2}) do
    {_status, newDate1} = convert_date(date1)
    {_status, newDate2} = convert_date(date2)
     
    difference = Date.diff(newDate1, newDate2)

    conn
    |> put_status(:ok)
    |> put_view(ReflectionsWeb.UserView)
    |> render("date_difference.json", difference: difference)
  end

  defp convert_date(date) do
    days = String.slice(date, 0, 2)
    months = String.slice(date, 2, 2)
    years = String.slice(date, 4, 4)

    {days_i, _remainder_of_binary} = Integer.parse(days)
    {months_i, _remainder_of_binary} = Integer.parse(months)
    {years_i, _remainder_of_binary} = Integer.parse(years)
    
    {years_i, months_i, days_i}
    |> Date.from_erl()
  end

end
