defmodule ReflectionsWeb.UserReflectionController do
  use ReflectionsWeb, :controller

  alias Reflections.Auth
  alias Reflections.Reflection
  alias Reflections.Reflection.UserReflection

  action_fallback ReflectionsWeb.FallbackController

  # Returns reflections only from the current logged user
  def index(conn, _params) do
    current_user_id = get_session(conn, :current_user_id)

    user_reflections = Reflection.list_user_reflections(current_user_id)
    render(conn, "index.json", user_reflections: user_reflections)
  end

  def public_index(conn, _params) do
    user_reflections = Reflection.list_public_user_reflections()
    render(conn, "index.json", user_reflections: user_reflections)
  end

  def create(conn, %{"user_reflection" => user_reflection_params}) do
    user = current_user(conn)
    
    with {:ok, %UserReflection{} = user_reflection} <- Reflection.create_user_reflection(user_reflection_params, user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_reflection_path(conn, :show, user_reflection))
      |> render("show.json", user_reflection: user_reflection)
    end
  end

  # TODO
  # Show reflection with id,
   # if it is public 
   # or belongs to current user 
   # or is shared with the current user
  def show(conn, %{"id" => id}) do
    user_reflection = Reflection.get_user_reflection!(id)
    render(conn, "show.json", user_reflection: user_reflection)
  end

  def update(conn, %{"id" => id, "user_reflection" => user_reflection_params}) do
    user_reflection = Reflection.get_user_reflection!(id)

    with {:ok, %UserReflection{} = user_reflection} <- Reflection.update_user_reflection(user_reflection, user_reflection_params) do
      render(conn, "show.json", user_reflection: user_reflection)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_reflection = Reflection.get_user_reflection!(id)

    with {:ok, %UserReflection{}} <- Reflection.delete_user_reflection(user_reflection) do
      send_resp(conn, :no_content, "")
    end
  end

  # Fetch date
  def public_fetch_date(conn, %{"date1" => date1}) do
    {_status, newDate1} = convert_date(date1)

    user_reflections = Reflection.list_public_user_reflections(newDate1)
    render(conn, "index.json", user_reflections: user_reflections)

  end

  def fetch_date(conn, %{"date1" => date1}) do
    {_status, newDate1} = convert_date(date1)

    current_user_id = get_session(conn, :current_user_id)

    user_reflections = Reflection.list_user_reflections(current_user_id, newDate1)
    render(conn, "index.json", user_reflections: user_reflections)
  end

  # Fetch dates
  def public_fetch_dates(conn, %{"date1" => date1, "date2" => date2}) do
    {_status, newDate1} = convert_date(date1)
    {_status, newDate2} = convert_date(date2)

    user_reflections = Reflection.list_public_user_reflections(newDate1, newDate2)
    render(conn, "index.json", user_reflections: user_reflections)
  end

  def fetch_dates(conn, %{"date1" => date1, "date2" => date2}) do
    {_status, newDate1} = convert_date(date1)
    {_status, newDate2} = convert_date(date2)

    current_user_id = get_session(conn, :current_user_id)

    user_reflections = Reflection.list_user_reflections(current_user_id, newDate1, newDate2)
    render(conn, "index.json", user_reflections: user_reflections)
  end

  def shared_with(conn, %{"user_id" => user_id}) do
    user = Auth.get_user!(user_id)

    user_reflections = Reflection.list_shared_user_reflections(user)
    render(conn, "index.json", user_reflections: user_reflections)
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

  defp current_user(conn) do
    current_user_id = get_session(conn, :user_id)
    |> Auth.get_user!
  end
end
