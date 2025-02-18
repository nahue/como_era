defmodule ComoEra.Bands.Band do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bands" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(band, attrs) do
    band
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
