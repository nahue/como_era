defmodule ComoEra.Repo.Migrations.CreateBands do
  use Ecto.Migration

  def change do
    create table(:bands) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
