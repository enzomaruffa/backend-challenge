defmodule Reflections.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :is_active, :boolean, default: false
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :reflections, Reflections.Reflection.UserReflection
    many_to_many :shared_reflections, Reflections.Reflection.UserReflection, join_through: "users_user_reflections" # I'm new!

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :password])
    |> validate_required([:email, :is_active, :password])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
    ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
  
end
