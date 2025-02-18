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
     |> assign(:notes_markdown, song.notes |> Earmark.as_html!())}
  end

  defp page_title(:show), do: "Show Song"
  defp page_title(:edit), do: "Edit Song"
end
