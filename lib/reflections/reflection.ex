defmodule Reflections.Reflection do
  @moduledoc """
  The Reflection context.
  """

  import Ecto.Query, warn: false
  alias Reflections.Repo

  alias Reflections.Reflection.UserReflection

  @doc """
  Returns the list of user_reflections.

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def list_user_reflections do
    Repo.all(UserReflection)
  end

  @doc """
  Gets a single user_reflection.

  Raises `Ecto.NoResultsError` if the User reflection does not exist.

  ## Examples

      iex> get_user_reflection!(123)
      %UserReflection{}

      iex> get_user_reflection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_reflection!(id), do: Repo.get!(UserReflection, id)

  @doc """
  Creates a user_reflection.

  ## Examples

      iex> create_user_reflection(%{field: value})
      {:ok, %UserReflection{}}

      iex> create_user_reflection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_reflection(attrs \\ %{}) do
    %UserReflection{}
    |> UserReflection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_reflection.

  ## Examples

      iex> update_user_reflection(user_reflection, %{field: new_value})
      {:ok, %UserReflection{}}

      iex> update_user_reflection(user_reflection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_reflection(%UserReflection{} = user_reflection, attrs) do
    user_reflection
    |> UserReflection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_reflection.

  ## Examples

      iex> delete_user_reflection(user_reflection)
      {:ok, %UserReflection{}}

      iex> delete_user_reflection(user_reflection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_reflection(%UserReflection{} = user_reflection) do
    Repo.delete(user_reflection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_reflection changes.

  ## Examples

      iex> change_user_reflection(user_reflection)
      %Ecto.Changeset{source: %UserReflection{}}

  """
  def change_user_reflection(%UserReflection{} = user_reflection) do
    UserReflection.changeset(user_reflection, %{})
  end
end