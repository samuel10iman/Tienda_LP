defmodule TiendaLpWeb.CarritoController do
  use TiendaLpWeb, :controller

  alias TiendaLp.Carritos
  alias TiendaLp.Productos

  def mostrar(conn, _params) do
    correo = get_session(conn, :correo) || "ginodiaz7923@gmail.com"
    carrito_id = get_session(conn, :carrito_id) || Ecto.UUID.generate()

    conn = put_session(conn, :carrito_id, carrito_id)

    items = TiendaLp.Carritos.listar_items_de_carrito_por_usuario(correo, carrito_id)

    render(conn, TiendaLpWeb.PageHTML, :carrito, items: items, carrito_id: carrito_id)
  end

  def agregar(conn, %{
        "producto_id" => producto_id,
        "carrito_id" => carrito_id,
        "cantidad" => cantidad,
        "correo" => correo
      }) do
    cantidad = String.to_integer(cantidad)
    producto_id = String.to_integer(producto_id)

    producto = Productos.get_producto!(producto_id)

    # Validar antes de agregar
    if cantidad > producto.stock do
      conn
      |> put_flash(:error, "La cantidad seleccionada supera el stock disponible.")
      |> redirect(to: ~p"/productos/show/#{producto_id}")
    else
      case Carritos.agregar_item(%{
             producto_id: producto_id,
             carrito_id: carrito_id,
             correo: correo,
             cantidad: cantidad
           }) do
        {:ok, _carrito} ->
          conn
          |> put_flash(:info, "Producto añadido al carrito.")
          |> redirect(to: ~p"/")

        {:error, changeset} ->
          errores = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
          IO.inspect(errores, label: "❌ Error al agregar al carrito")

          conn
          |> put_flash(:error, "No se pudo agregar al carrito: revisa los datos ingresados.")
          |> redirect(to: ~p"/productos/show/#{producto_id}")
      end
    end
  end
end
