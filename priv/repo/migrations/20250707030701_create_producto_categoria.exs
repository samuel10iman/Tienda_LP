defmodule TiendaLp.Repo.Migrations.CreateProductoCategoria do
  use Ecto.Migration

  def change do
    create table(:producto_categoria, primary_key: false) do
      add :producto_id, references(:productos, column: :id), null: false
      add :categoria_id, references(:categorias, column: :id), null: false
    end

    create unique_index(:producto_categoria, [:producto_id, :categoria_id],
             name: :producto_categoria_pk
           )
  end
end
