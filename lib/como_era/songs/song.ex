defmodule ComoEra.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  alias ComoEra.Bands.Band

  schema "songs" do
    field :name, :string
    field :notes, :string

    belongs_to :band, Band

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:name, :notes, :band_id])
    |> validate_required([:name, :notes, :band_id])
  end
end
