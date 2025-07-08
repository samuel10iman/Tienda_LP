defmodule TiendaLp.Repo.Migrations.AddCarritoIdToCarrito do
  use Ecto.Migration

  def change do
    alter table(:carrito) do
      add :carrito_id, :uuid, null: false
    end

    create index(:carrito, [:carrito_id])
  end
end
