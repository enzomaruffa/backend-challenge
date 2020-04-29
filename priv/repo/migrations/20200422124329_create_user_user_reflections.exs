defmodule Reflections.Repo.Migrations.CreateUserUserReflections do
  use Ecto.Migration

  def change do
    create table(:users_user_reflections) do
      add :user_id, references(:users)
      add :user_reflection_id, references(:user_reflections)
    end

    create unique_index(:users_user_reflections, [:user_id, :reflection_id])
  end

end
