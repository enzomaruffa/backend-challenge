defmodule Reflections.Repo.Migrations.CreateUserReflections do
  use Ecto.Migration

  def change do
    create table(:user_reflections) do
      add :text, :string
      add :public, :boolean, default: false
      add :user_id, references(:users)

      timestamps(type: :utc_datetime_usec)
    end

  end
end
