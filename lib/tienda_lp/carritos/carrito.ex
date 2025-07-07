defmodule TiendaLp.Carrito.Carrito do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carrito" do
    field :correo, :string
    field :cantidad, :integer
    field :estado, :string, default: "pendiente"

    belongs_to :producto, TiendaLp.Productos.Producto,
      foreign_key: :producto_id,
      references: :id,
      type: :integer

    timestamps()
  end

  @doc false
  def changeset(carrito, attrs) do
    carrito
    |> cast(attrs, [:correo, :producto_id, :cantidad, :estado])
    |> validate_required([:correo, :producto_id, :cantidad])
    |> validate_inclusion(:estado, ["pendiente", "confirmado", "cancelado"])
  end
end
