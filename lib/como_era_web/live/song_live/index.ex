defmodule ComoEraWeb.SongLive.Index do
  use ComoEraWeb, :live_view

  alias ComoEra.Songs
  alias ComoEra.Songs.Song

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)
      |> assign(:form, to_form(params))
    {:noreply, socket}
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

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Songs")
    |> assign(:song, nil)
    |> stream(:songs, Songs.filter_songs(params), reset: true)
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

  def handle_event("search", params, socket) do
    params =
      params
      |> Map.take(~w(q))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/songs?#{params}")
    {:noreply, socket}
  end
end
