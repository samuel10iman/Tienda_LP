defmodule TiendaLp.Productos.Producto do
  use Ecto.Schema
  import Ecto.Changeset

  schema "productos" do
    field :nombre, :string
    field :stock, :integer
    field :precio, :decimal
    field :imagen, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(producto, attrs) do
    producto
    |> cast(attrs, [:nombre, :stock, :precio, :imagen])
    |> validate_required([:nombre, :stock, :precio])
  end
end
