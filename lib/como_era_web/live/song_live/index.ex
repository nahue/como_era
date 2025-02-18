defmodule ComoEraWeb.SongLive.Index do
  use ComoEraWeb, :live_view

  alias ComoEra.Songs
  alias ComoEra.Songs.Song

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :songs, Songs.list_songs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Song")
    |> assign(:song, Songs.get_song!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Song")
    |> assign(:song, %Song{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Songs")
    |> assign(:song, nil)
  end

  @impl true
  def handle_info({ComoEraWeb.SongLive.FormComponent, {:saved, song}}, socket) do
    {:noreply, stream_insert(socket, :songs, song)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    song = Songs.get_song!(id)
    {:ok, _} = Songs.delete_song(song)

    {:noreply, stream_delete(socket, :songs, song)}
  end
end
