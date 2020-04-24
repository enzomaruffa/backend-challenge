defmodule ReflectionsWeb.UserReflectionController do
  use ReflectionsWeb, :controller

  alias Reflections.Reflection
  alias Reflections.Reflection.UserReflection

  action_fallback ReflectionsWeb.FallbackController

  def index(conn, _params) do
    user_reflections = Reflection.list_user_reflections()
    render(conn, "index.json", user_reflections: user_reflections)
  end

  def create(conn, %{"user_reflection" => user_reflection_params}) do
    with {:ok, %UserReflection{} = user_reflection} <- Reflection.create_user_reflection(user_reflection_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_reflection_path(conn, :show, user_reflection))
      |> render("show.json", user_reflection: user_reflection)
    end
  end

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

  def fetch_user_email(conn, %{"email" => email}) do

  end

  def fetch_reflection_id(conn, %{"id" => id}) do

  end

  def fetch_dates(conn, %{"date1" => date1}) do

  end

  def fetch_dates(conn, %{"date1" => date1, "date2" => date2}) do

  end
end
