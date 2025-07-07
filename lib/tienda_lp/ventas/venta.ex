defmodule TiendaLp.Ventas.Venta do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ventas" do
    field :correo, :string
    field :cantidad, :integer

    belongs_to :producto, TiendaLp.Productos.Producto,
      foreign_key: :producto_id,
      references: :id,
      type: :integer

    timestamps()
  end

  @doc false
  def changeset(venta, attrs) do
    venta
    |> cast(attrs, [:correo, :producto_id, :cantidad])
    |> validate_required([:correo, :producto_id, :cantidad])
    |> validate_number(:cantidad, greater_than: 0)
  end
end
