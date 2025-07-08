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

defmodule TiendaLp.Ventas do
  @moduledoc """
  Funciones para registrar ventas y consultar historial.
  """

  import Ecto.Query, warn: false
  alias TiendaLp.Repo
  alias TiendaLp.Ventas.Venta

  # 🔹 Crear una venta
  def crear_venta(%{correo: correo, producto_id: producto_id, cantidad: cantidad}) do
    %Venta{}
    |> Venta.changeset(%{correo: correo, producto_id: producto_id, cantidad: cantidad})
    |> Repo.insert()
  end

  # 🔹 Listar todas las ventas (opcional, útil para administración)
  def listar_ventas do
    Repo.all(Venta)
  end
end
