defmodule Reflections.Reflection.UserReflection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_reflections" do
    field :public, :boolean
    field :text, :string
    
    belongs_to :user, Reflections.Auth.User
    many_to_many :shared_users, Reflections.Auth.User, join_through: "users_user_reflections" # I'm new!

    timestamps(type: :utc_datetime_usec)

  end

  @doc false
  def changeset(user_reflection, attrs) do
    user_reflection
    |> cast(attrs, [:text, :public])
    |> validate_required([:text, :public])
  end
end
