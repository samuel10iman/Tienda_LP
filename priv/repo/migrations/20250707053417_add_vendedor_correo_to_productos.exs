defmodule TiendaLp.Repo.Migrations.AddVendedorCorreoToProductos do
  use Ecto.Migration

  def change do
    alter table(:productos) do
      add :vendedor_correo, references(:usuarios, column: :correo, type: :string), null: false
    end
  end
end
