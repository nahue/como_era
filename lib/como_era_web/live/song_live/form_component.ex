defmodule ComoEraWeb.SongLive.FormComponent do
  use ComoEraWeb, :live_view

  alias ComoEra.Songs
  alias ComoEra.Songs.Song
  alias ComoEra.Bands

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> apply_action(socket.assigns.live_action, params)
      |> assign(:bands, Bands.band_options())
    {:ok, socket}
  end

  defp page_title(:new), do: "New Song"
  defp page_title(:edit), do: "Edit Song"

  defp apply_action(socket, :edit, %{"id" => id}) do
    song = Songs.get_song!(id)

    socket
    |> assign(:song, song)
    |> assign(:form, to_form(Songs.change_song(song)))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:song, %Song{})
    |> assign(:form, to_form(Songs.change_song(%Song{}, %{})))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage song records in your database.</:subtitle>
      </.header>

      <.simple_form for={@form} id="song-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:band_id]} type="select" label="Band" options={@bands} />

        <div id="song_notes_container" phx-update="ignore" phx-hook="RichText">
          <.input type="textarea" field={@form[:notes]} id="song_notes_input" />
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Song</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"song" => song_params}, socket) do
    changeset = Songs.change_song(socket.assigns.song, song_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"song" => song_params}, socket) do
    save_song(socket, socket.assigns.live_action, song_params)
  end

  defp save_song(socket, :edit, song_params) do
    case Songs.update_song(socket.assigns.song, song_params) do
      {:ok, song} ->
        notify_parent({:saved, song})

        {:noreply,
         socket
         |> put_flash(:info, "Song updated successfully")
         |> push_navigate(to: "/songs/#{song.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_song(socket, :new, song_params) do
    case Songs.create_song(song_params) do
      {:ok, song} ->
        notify_parent({:saved, song})

        {:noreply,
         socket
         |> put_flash(:info, "Song created successfully")
         |> push_navigate(to: "/songs/#{song.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
