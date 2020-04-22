defmodule ReflectionsWeb.UserReflectionView do
  use ReflectionsWeb, :view
  alias ReflectionsWeb.UserReflectionView

  def render("index.json", %{user_reflections: user_reflections}) do
    %{data: render_many(user_reflections, UserReflectionView, "user_reflection.json")}
  end

  def render("show.json", %{user_reflection: user_reflection}) do
    %{data: render_one(user_reflection, UserReflectionView, "user_reflection.json")}
  end

  def render("user_reflection.json", %{user_reflection: user_reflection}) do
    %{id: user_reflection.id,
      text: user_reflection.text,
      public: user_reflection.public}
  end
end
