defmodule TiendaLp.Productos do
  import Ecto.Query
  alias TiendaLp.Repo
  alias TiendaLp.Productos.Producto

  def buscar_productos(params \\ %{}) do
    Producto
    |> where(^filtro_nombre(params["q"]))
    |> maybe_precio_max(params["precio_max"])
    |> maybe_categoria(params["categoria_id"])
    |> preload([:vendedor])
    |> Repo.all()
  end

  # 🔹 Disminuir stock de un producto
  def disminuir_stock(producto_id, cantidad_a_restar) do
    producto = Repo.get!(Producto, producto_id)

    if producto.stock < cantidad_a_restar do
      {:error, :stock_insuficiente}
    else
      nuevo_stock = producto.stock - cantidad_a_restar

      producto
      |> Producto.changeset(%{stock: nuevo_stock})
      |> Repo.update()
    end
  end



  defp filtro_nombre(nil), do: dynamic(true)
  defp filtro_nombre(""), do: dynamic(true)
  defp filtro_nombre(q), do: dynamic([p], ilike(p.nombre, ^"%#{q}%"))

  defp maybe_precio_max(query, nil), do: query
  defp maybe_precio_max(query, ""), do: query

  defp maybe_precio_max(query, precio_max) do
    precio_max = String.trim(precio_max)
    IO.inspect(precio_max, label: "Precio max recibido")

    case Decimal.parse(precio_max) do
      {dec, ""} ->
        IO.inspect(dec, label: "Decimal parseado")
        where(query, [p], p.precio <= ^dec)

      _ ->
        IO.puts("No se pudo parsear el precio_max")
        query
    end
  end

  defp maybe_categoria(query, nil), do: query
  defp maybe_categoria(query, ""), do: query

  defp maybe_categoria(query, categoria_id) do
    where(query, [p], p.categoria_id == ^String.to_integer(categoria_id))
  end

  def get_producto!(id) do
    Repo.get!(Producto, id)
  end

  # Listar productos similares por categoría, excluyendo el actual
  def listar_productos_similares(categoria_id, id_actual) do
    Producto
    |> where([p], p.categoria_id == ^categoria_id and p.id != ^id_actual)
    |> limit(6)
    |> Repo.all()
  end


end

defmodule TiendaLp.Productos.Producto do
  use Ecto.Schema
  import Ecto.Changeset

  schema "productos" do
    field :nombre, :string
    field :stock, :integer
    field :precio, :decimal
    field :imagen, :string
    field :categoria_id, :integer

    belongs_to :vendedor, TiendaLp.Usuarios.Usuario,
      foreign_key: :vendedor_correo,
      references: :correo,
      type: :string

    timestamps()
  end

  @doc false
  def changeset(producto, attrs) do
    producto
    |> cast(attrs, [:nombre, :stock, :precio, :imagen, :categoria_id, :vendedor_correo])
    |> validate_required([:nombre, :stock, :precio, :categoria_id, :vendedor_correo])
  end
end
