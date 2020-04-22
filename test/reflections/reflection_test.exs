defmodule Reflections.ReflectionTest do
  use Reflections.DataCase

  alias Reflections.Reflection

  describe "user_reflections" do
    alias Reflections.Reflection.UserReflection

    @valid_attrs %{public: 42, text: "some text"}
    @update_attrs %{public: 43, text: "some updated text"}
    @invalid_attrs %{public: nil, text: nil}

    def user_reflection_fixture(attrs \\ %{}) do
      {:ok, user_reflection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reflection.create_user_reflection()

      user_reflection
    end

    test "list_user_reflections/0 returns all user_reflections" do
      user_reflection = user_reflection_fixture()
      assert Reflection.list_user_reflections() == [user_reflection]
    end

    test "get_user_reflection!/1 returns the user_reflection with given id" do
      user_reflection = user_reflection_fixture()
      assert Reflection.get_user_reflection!(user_reflection.id) == user_reflection
    end

    test "create_user_reflection/1 with valid data creates a user_reflection" do
      assert {:ok, %UserReflection{} = user_reflection} = Reflection.create_user_reflection(@valid_attrs)
      assert user_reflection.creation_date == ~T[14:00:00.000000]
      assert user_reflection.public == 42
      assert user_reflection.text == "some text"
    end

    test "create_user_reflection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reflection.create_user_reflection(@invalid_attrs)
    end

    test "update_user_reflection/2 with valid data updates the user_reflection" do
      user_reflection = user_reflection_fixture()
      assert {:ok, %UserReflection{} = user_reflection} = Reflection.update_user_reflection(user_reflection, @update_attrs)
      assert user_reflection.creation_date == ~T[15:01:01.000000]
      assert user_reflection.public == 43
      assert user_reflection.text == "some updated text"
    end

    test "update_user_reflection/2 with invalid data returns error changeset" do
      user_reflection = user_reflection_fixture()
      assert {:error, %Ecto.Changeset{}} = Reflection.update_user_reflection(user_reflection, @invalid_attrs)
      assert user_reflection == Reflection.get_user_reflection!(user_reflection.id)
    end

    test "delete_user_reflection/1 deletes the user_reflection" do
      user_reflection = user_reflection_fixture()
      assert {:ok, %UserReflection{}} = Reflection.delete_user_reflection(user_reflection)
      assert_raise Ecto.NoResultsError, fn -> Reflection.get_user_reflection!(user_reflection.id) end
    end

    test "change_user_reflection/1 returns a user_reflection changeset" do
      user_reflection = user_reflection_fixture()
      assert %Ecto.Changeset{} = Reflection.change_user_reflection(user_reflection)
    end
  end
end
