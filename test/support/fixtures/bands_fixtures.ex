defmodule ComoEra.BandsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ComoEra.Bands` context.
  """

  @doc """
  Generate a band.
  """
  def band_fixture(attrs \\ %{}) do
    {:ok, band} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ComoEra.Bands.create_band()

    band
  end
end
