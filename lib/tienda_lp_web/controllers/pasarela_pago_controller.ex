defmodule TiendaLpWeb.PasarelaPagoController do
  use TiendaLpWeb, :controller

  alias TiendaLp.Carritos
  alias TiendaLp.Ventas
  alias TiendaLp.Productos

  def mostrar(conn, _params) do
    render(conn, TiendaLpWeb.PageHTML, :pasarela_pago, layout: false)

  end

  def confirmar_pago(conn, %{
        "nombre" => _nombre,
        "apellido" => _apellido,
        "tarjeta" => _tarjeta,
        "cvv" => _cvv,
        "fecha_vencimiento" => _fecha_vencimiento
      }) do
    correo = get_session(conn, :correo) || "ginodiaz7923@gmail.com"
    carrito_id = get_session(conn, :carrito_id) || "8e249ee0-11db-47fb-8709-91a5dfc10e38"

    items = Carritos.listar_items_de_carrito_por_usuario(correo, carrito_id)

    if items == [] do
      conn
      |> put_flash(:error, "El carrito está vacío.")
      |> redirect(to: ~p"/carrito")
    else
      resultado =
        Enum.reduce_while(items, :ok, fn item, _acc ->
          producto = item.producto
          cantidad = item.cantidad

          case Productos.disminuir_stock(producto.id, cantidad) do
            {:ok, _producto_actualizado} ->
              Ventas.crear_venta(%{
                producto_id: producto.id,
                correo: correo,
                cantidad: cantidad
              })

              {:cont, :ok}

            {:error, :stock_insuficiente} ->
              {:halt, {:error, "Stock insuficiente para #{producto.nombre}"}}
          end
        end)

      case resultado do
        :ok ->
          Carritos.actualizar_estado(carrito_id, "pagado")

          conn
          |> put_flash(:info, "Compra realizada con éxito.")
          |> redirect(to: ~p"/")

        {:error, msg} ->
          conn
          |> put_flash(:error, msg)
          |> redirect(to: ~p"/carrito")
      end
    end
  end
end
