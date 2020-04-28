defmodule ReflectionsWeb.UserReflectionControllerTest do
  use ReflectionsWeb.ConnCase

  alias Reflections.Auth
  alias Reflections.Reflection
  alias Reflections.Reflection.UserReflection
  alias Plug.Test

  @create_attrs %{
    public: true,
    text: "some text"
  }
  @update_attrs %{
    public: false,
    text: "some updated text"
  }
  @invalid_attrs %{public: nil, text: nil}

  @current_user_attrs %{
    email: "some current user email",
    is_active: true,
    password: "some current user password"
  }

  def fixture(:current_user) do
    {:ok, current_user} = Auth.create_user(@current_user_attrs)
    current_user
  end

  def fixture(:user_reflection) do
    {:ok, user_reflection} = Reflection.create_user_reflection(@create_attrs)
    user_reflection
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: _current_user} = setup_current_user(conn)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_reflections", %{conn: conn} do
      conn = get(conn, Routes.user_reflection_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all public user_reflections", %{conn: conn} do
      conn = get(conn, Routes.user_reflection_path(conn, :public_index))
      assert json_response(conn, 200)["data"] == []
    end

    # test "lists all user_reflections from date1 to now", %{conn: conn} do
    #   conn = post(conn, Routes.user_reflection_path(conn, :fetch_user_email), @current_user_attrs.email)
    #   assert json_response(conn, 200)["data"] == []
    # end

    # test "get a single user_reflection by id", %{conn: conn} do
    #   conn = post(conn, Routes.user_reflection_path(conn, :fetch_reflection_id), %{ id: 1 })
    #   assert json_response(conn, 200)["data"] == []
    # end
  end

  describe "create user_reflection" do
    test "renders user_reflection when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_reflection_path(conn, :create), user_reflection: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_reflection_path(conn, :show, id))

      assert %{
               "id" => id,
               "public" => true,
               "text" => "some text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_reflection_path(conn, :create), user_reflection: @invalid_attrs)
      assert json_response(conn, 422) == "Unprocessable Entity"
    end
  end

  describe "update user_reflection" do
    setup [:create_user_reflection]

    test "renders user_reflection when data is valid", %{conn: conn, user_reflection: %UserReflection{id: id} = user_reflection} do
      conn = put(conn, Routes.user_reflection_path(conn, :update, user_reflection), user_reflection: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_reflection_path(conn, :show, id))

      assert %{
               "id" => id,
               "public" => false,
               "text" => "some updated text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_reflection: user_reflection} do
      conn = put(conn, Routes.user_reflection_path(conn, :update, user_reflection), user_reflection: @invalid_attrs)
      assert json_response(conn, 422) == "Unprocessable Entity"
    end
  end

  describe "delete user_reflection" do
    setup [:create_user_reflection]

    test "deletes chosen user_reflection", %{conn: conn, user_reflection: user_reflection} do
      conn = delete(conn, Routes.user_reflection_path(conn, :delete, user_reflection))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_reflection_path(conn, :show, user_reflection))
      end
    end
  end

  defp create_user_reflection(_) do
    user_reflection = fixture(:user_reflection)
    {:ok, user_reflection: user_reflection}
  end

  defp setup_current_user(conn) do
    current_user = fixture(:current_user)
    {
      :ok,
      conn: Test.init_test_session(conn, current_user_id: current_user.id),
      current_user: current_user
    }
  end
end
