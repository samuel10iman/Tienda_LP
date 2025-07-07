defmodule TiendaLp.Repo.Migrations.AddTimestampsToProductos do
  use Ecto.Migration

  def change do
    alter table(:productos) do
      timestamps()
    end
  end
end
