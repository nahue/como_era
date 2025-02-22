defmodule ComoEraWeb.SongLive.Show do
  use ComoEraWeb, :live_view

  alias ComoEra.Songs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    song = Songs.get_song!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:song, song)
     |> assign(:notes_markdown, get_song_notes(song.notes))
     |> assign(:next_song, Songs.get_next_song(song.id))
     |> assign(:previous_song, Songs.get_previous_song(song.id))}
  end

  defp page_title(:show), do: "Show Song"
  defp page_title(:edit), do: "Edit Song"

  def get_song_notes(nil), do: nil

  def get_song_notes(notes) do
    notes |> Earmark.as_html!()
  end

end
