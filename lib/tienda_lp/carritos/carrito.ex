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

defmodule TiendaLp.Carritos do
  @moduledoc """
  El contexto para operaciones del carrito de compras.
  """

  import Ecto.Query, warn: false
  alias TiendaLp.Repo

  alias TiendaLp.Carrito.Carrito

  # Lista todos los productos en el carrito de un usuario
  def listar_carrito_por_usuario(correo) do
    Repo.all(
      from c in Carrito,
        where: c.correo == ^correo,
        preload: [:producto]
    )
  end

  # Agrega un producto al carrito
  def agregar_al_carrito(attrs) do
    %Carrito{}
    |> Carrito.changeset(attrs)
    |> Repo.insert()
  end

  # Actualiza la cantidad de un producto en el carrito
  def actualizar_carrito(%Carrito{} = carrito, attrs) do
    carrito
    |> Carrito.changeset(attrs)
    |> Repo.update()
  end

  # Elimina un producto del carrito
  def eliminar_del_carrito(%Carrito{} = carrito) do
    Repo.delete(carrito)
  end

  # Busca un item del carrito por id
  def obtener_item_carrito!(id), do: Repo.get!(Carrito, id)
end
