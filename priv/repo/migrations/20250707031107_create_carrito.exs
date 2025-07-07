defmodule TiendaLp.Repo.Migrations.CreateCarrito do
  use Ecto.Migration

  def change do
    create table(:carrito) do
      add :correo, references(:usuarios, column: :correo, type: :string), null: false
      add :producto_id, references(:productos, column: :id), null: false
      add :cantidad, :integer, null: false
      add :estado, :string, default: "pendiente"

      timestamps()
    end
  end
end
