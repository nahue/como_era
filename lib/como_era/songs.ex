defmodule ComoEra.Songs do
  @moduledoc """
  The Songs context.
  """

  import Ecto.Query, warn: false
  alias ComoEra.Repo

  alias ComoEra.Songs.Song

  @doc """
  Returns the list of songs.

  ## Examples

      iex> list_songs()
      [%Song{}, ...]

  """
  def list_songs do
    Repo.all(Song) |> Repo.preload(:band)
  end

  def filter_songs(filter) do
    Song
    |> search_by(filter["q"])
    |> preload(:band)
    |> Repo.all()
  end

  def search_by(query, q) when q in [nil, ""], do: query

  def search_by(query, q) do
    from s in query, where: like(s.name, ^"%#{q}%")
  end

  @doc """
  Getsje song.

  Raises `Ecto.NoResultsError` if the Song does not exist.

  ## Examples

      iex> get_song!(123)
      %Song{}

      iex> get_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song!(id) do
    Repo.get!(Song, id)
    |> Repo.preload(:band)
  end

  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{field: value})
      {:ok, %Song{}}

      iex> create_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(attrs \\ %{}) do
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update_song(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update_song(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a song.

  ## Examples

      iex> delete_song(song)
      {:ok, %Song{}}

      iex> delete_song(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{data: %Song{}}

  """
  def change_song(%Song{} = song, attrs \\ %{}) do
    Song.changeset(song, attrs)
  end

  @doc """
  Gets the next song ordered by ID.
  Returns nil if there is no next song.

  ## Examples

      iex> get_next_song(1)
      %Song{}

      iex> get_next_song(999)
      nil

  """
  def get_next_song(current_id) do
    from(s in Song,
      where: s.id > ^current_id,
      order_by: [asc: s.id],
      limit: 1)
    |> Repo.one()
    |> Repo.preload(:band)
  end

  @doc """
  Gets the previous song ordered by ID.
  Returns nil if there is no previous song.

  ## Examples

      iex> get_previous_song(2)
      %Song{}

      iex> get_previous_song(1)
      nil

  """
  def get_previous_song(current_id) do
    from(s in Song,
      where: s.id < ^current_id,
      order_by: [desc: s.id],
      limit: 1)
    |> Repo.one()
    |> Repo.preload(:band)
  end

end
