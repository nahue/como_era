defmodule ComoEra.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :name, :string
      add :band_id, references(:bands, on_delete: :nothing)
      add :notes, :text

      timestamps(type: :utc_datetime)
    end

    create index(:songs, [:band_id])
  end
end
