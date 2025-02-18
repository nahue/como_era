defmodule ComoEraWeb.BandLive.Index do
  use ComoEraWeb, :live_view

  alias ComoEra.Bands
  alias ComoEra.Bands.Band

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :bands, Bands.list_bands())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Band")
    |> assign(:band, Bands.get_band!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Band")
    |> assign(:band, %Band{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bands")
    |> assign(:band, nil)
  end

  @impl true
  def handle_info({ComoEraWeb.BandLive.FormComponent, {:saved, band}}, socket) do
    {:noreply, stream_insert(socket, :bands, band)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    band = Bands.get_band!(id)
    {:ok, _} = Bands.delete_band(band)

    {:noreply, stream_delete(socket, :bands, band)}
  end
end
