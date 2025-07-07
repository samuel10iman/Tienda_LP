defmodule TiendaLp.Productos.Producto do
  use Ecto.Schema
  import Ecto.Changeset

  schema "productos" do
    field :nombre, :string
    field :stock, :integer
    field :precio, :decimal
    field :imagen, :string

    belongs_to :vendedor, TiendaLp.Usuarios.Usuario,
      foreign_key: :vendedor_correo,
      references: :correo,
      type: :string

    timestamps()
  end

  @doc false
  def changeset(producto, attrs) do
    producto
    |> cast(attrs, [:nombre, :stock, :precio, :imagen])
    |> validate_required([:nombre, :stock, :precio])
  end
end
