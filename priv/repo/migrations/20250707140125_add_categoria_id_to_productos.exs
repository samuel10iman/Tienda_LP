defmodule TiendaLp.Repo.Migrations.AddCategoriaIdToProductos do
  use Ecto.Migration

  def change do
    alter table(:productos) do
      add :categoria_id, :integer
    end
  end
end
