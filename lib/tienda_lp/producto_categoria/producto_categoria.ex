defmodule TiendaLp.ProductoCategoria.ProductoCategoria do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "producto_categoria" do
    belongs_to :producto, TiendaLp.Productos.Producto, foreign_key: :producto_id
    belongs_to :categoria, TiendaLp.Categorias.Categoria, foreign_key: :categoria_id

    # No timestamps porque no se definieron en la migración
  end

  @doc false
  def changeset(producto_categoria, attrs) do
    producto_categoria
    |> cast(attrs, [:producto_id, :categoria_id])
    |> validate_required([:producto_id, :categoria_id])
    |> unique_constraint([:producto_id, :categoria_id], name: :producto_categoria_pk)
  end
end
