defmodule ComoEraWeb.BandLive.FormComponent do
  use ComoEraWeb, :live_component

  alias ComoEra.Bands

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage band records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="band-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Band</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{band: band} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Bands.change_band(band))
     end)}
  end

  @impl true
  def handle_event("validate", %{"band" => band_params}, socket) do
    changeset = Bands.change_band(socket.assigns.band, band_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"band" => band_params}, socket) do
    save_band(socket, socket.assigns.action, band_params)
  end

  defp save_band(socket, :edit, band_params) do
    case Bands.update_band(socket.assigns.band, band_params) do
      {:ok, band} ->
        notify_parent({:saved, band})

        {:noreply,
         socket
         |> put_flash(:info, "Band updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_band(socket, :new, band_params) do
    case Bands.create_band(band_params) do
      {:ok, band} ->
        notify_parent({:saved, band})

        {:noreply,
         socket
         |> put_flash(:info, "Band created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
