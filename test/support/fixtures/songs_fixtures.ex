defmodule ComoEra.SongsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ComoEra.Songs` context.
  """

  @doc """
  Generate a song.
  """
  def song_fixture(attrs \\ %{}) do
    {:ok, song} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ComoEra.Songs.create_song()

    song
  end
end
