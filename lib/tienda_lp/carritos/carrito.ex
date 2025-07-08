defmodule TiendaLp.Carrito.Carrito do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carrito" do
    field :correo, :string
    field :cantidad, :integer
    field :estado, :string, default: "pendiente"
    field :carrito_id, Ecto.UUID

    belongs_to :producto, TiendaLp.Productos.Producto,
      foreign_key: :producto_id,
      references: :id,
      type: :integer

    timestamps()
  end

  @doc false
  def changeset(carrito, attrs) do
    carrito
    |> cast(attrs, [:correo, :producto_id, :cantidad, :estado, :carrito_id])
    |> validate_required([:correo, :producto_id, :cantidad, :carrito_id])
    |> validate_inclusion(:estado, ["pendiente", "confirmado", "cancelado"])
  end
end

defmodule TiendaLp.Carritos do
  @moduledoc """
  El contexto para operaciones del carrito de compras, permitiendo múltiples
  carritos paralelos por usuario y evitando productos duplicados en un mismo carrito.
  """

  import Ecto.Query, warn: false
  alias TiendaLp.Repo
  alias TiendaLp.Carrito.Carrito

  # 🔹 Generar un UUID para un nuevo carrito
  def generar_carrito_id do
    Ecto.UUID.generate()
  end

  # 🔹 Agregar producto al carrito, o aumentar cantidad si ya existe
  def agregar_item(%{
        correo: correo,
        producto_id: producto_id,
        cantidad: cantidad,
        carrito_id: carrito_id
      }) do
    existente =
      Repo.get_by(Carrito,
        correo: correo,
        producto_id: producto_id,
        carrito_id: carrito_id,
        estado: "pendiente"
      )

    if existente do
      nuevo_total = existente.cantidad + cantidad

      existente
      |> Carrito.changeset(%{cantidad: nuevo_total})
      |> Repo.update()
    else
      %Carrito{}
      |> Carrito.changeset(%{
        correo: correo,
        producto_id: producto_id,
        cantidad: cantidad,
        carrito_id: carrito_id
      })
      |> Repo.insert()
    end
  end

  # 🔹 Listar todos los productos de un carrito específico (por carrito_id)
  def listar_items_de_carrito(carrito_id) do
    Repo.all(
      from c in Carrito,
        where: c.carrito_id == ^carrito_id,
        preload: [:producto]
    )
  end

  # 🔹 Actualizar cantidad o estado de un ítem
  def actualizar_item(%Carrito{} = item, attrs) do
    item
    |> Carrito.changeset(attrs)
    |> Repo.update()
  end

  # 🔹 Eliminar un solo ítem del carrito
  def eliminar_item(%Carrito{} = item) do
    Repo.delete(item)
  end

  # 🔹 Vaciar todo el carrito (por carrito_id)
  def vaciar_carrito(carrito_id) do
    from(c in Carrito, where: c.carrito_id == ^carrito_id)
    |> Repo.delete_all()
  end

  # 🔹 Obtener un ítem específico por su id
  def obtener_item!(id), do: Repo.get!(Carrito, id)

  # 🔹 Contar ítems en un carrito (opcional para mostrar número de productos en el ícono)
  def contar_items(carrito_id) do
    from(c in Carrito,
      where: c.carrito_id == ^carrito_id,
      select: sum(c.cantidad)
    )
    |> Repo.one()
    |> Kernel.||(0)
  end

  def listar_items_de_carrito_por_usuario(correo, carrito_id) do
  if is_nil(correo) or is_nil(carrito_id) do
    []
  else
    Repo.all(
      from c in Carrito,
        where: c.correo == ^correo and c.carrito_id == ^carrito_id,
        preload: [:producto]
    )
  end
end


  # 🔹 Actualizar el estado de todos los ítems de un carrito a "confirmado" (o el estado que se pase)
  def actualizar_estado(carrito_id, nuevo_estado) do
    from(c in TiendaLp.Carrito.Carrito,
      where: c.carrito_id == ^carrito_id
    )
    |> TiendaLp.Repo.update_all(set: [estado: nuevo_estado])
  end
end
