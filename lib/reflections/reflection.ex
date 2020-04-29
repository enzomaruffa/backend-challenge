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
  def create_user_reflection(attrs \\ %{}, user) do
    # Adds belongs to with current user
    user
    |> Ecto.build_assoc(:reflections, attrs)
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

  @doc """
  Returns the list of all public user_reflections.

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def list_public_user_reflections do
    Repo.all(from r in UserReflection, where: r.public == ^true)
    # Repo.all(UserReflection)
  end


  @doc """
  Returns the list of user_reflections from user with id user_id.

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def list_user_reflections(user_id) do
    Repo.all(from r in UserReflection, where: r.user_id == ^user_id)
  end

  @doc """
  Returns the list of public user_reflections, from date1 to now.

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def list_public_user_reflections(date1) do
    Repo.all(from r in UserReflection, where:
      fragment("?::date", r.inserted_at) >= ^date1
    )
  end

  @doc """
  Returns the list of user_reflections from user with id user_id, from date1 to now.

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def list_user_reflections(user_id, date1) do
    Repo.all(from r in UserReflection, where: 
      r.user_id == ^user_id and 
      fragment("?::date", r.inserted_at) >= ^date1
    )
  end

  @doc """
  Returns the list of public user_reflections, from date1 to date2.

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def list_public_user_reflections(date1, date2) do
    Repo.all(from r in UserReflection, where:
      fragment("?::date", r.inserted_at) >= ^date1 and
      fragment("?::date", r.inserted_at) <= ^date2
    )
  end

  @doc """
  Returns the list of user_reflections from user with id user_id, from date1 to date2.

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def list_user_reflections(user_id, date1, date2) do
    Repo.all(from r in UserReflection, where:
      r.user_id == ^user_id and 
      fragment("?::date", r.inserted_at) >= ^date1 and
      fragment("?::date", r.inserted_at) <= ^date2
    )
  end


  @doc """
  Returns the list of user_reflections shared with user

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def list_shared_user_reflections(user) do
    Repo.all(Ecto.assoc(user, :shared_reflections))
  end


  @doc """
  Adds sharing between a user and a reflection

  ## Examples

      iex> list_user_reflections()
      [%UserReflection{}, ...]

  """
  def add_sharing(user, reflection) do
    user = Repo.preload(user, [:shared_reflections])

    user_changeset = Ecto.Changeset.change(user)
    |> Ecto.Changeset.put_assoc(:shared_reflections, [reflection])

    Repo.update!(shared_user_changeset)
  end

end
