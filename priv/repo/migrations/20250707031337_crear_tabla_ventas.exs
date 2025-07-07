defmodule TiendaLp.Repo.Migrations.CrearTablaVentas do
  use Ecto.Migration

  def change do
    create table(:ventas) do
      add :correo, references(:usuarios, column: :correo, type: :string)
      add :producto_id, references(:productos)
      add :cantidad, :integer, null: false
    end
  end
end
