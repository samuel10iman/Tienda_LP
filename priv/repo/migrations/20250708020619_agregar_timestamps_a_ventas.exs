defmodule TiendaLp.Repo.Migrations.AgregarTimestampsAVentas do
  use Ecto.Migration

  def change do
    alter table(:ventas) do
      timestamps()
    end
  end
end
