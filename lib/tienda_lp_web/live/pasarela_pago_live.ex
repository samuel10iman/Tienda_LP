defmodule TiendaLpWeb.PasarelaPagoLive do
  use TiendaLpWeb, :live_view

  alias TiendaLp.Carritos
  alias TiendaLp.Ventas
  alias TiendaLp.Productos

  def mount(_params, session, socket) do
    correo = session["correo"] || "anonimo@correo.com"
    carrito_id = session["carrito_id"]

    items = Carritos.listar_items_de_carrito_por_usuario(correo, carrito_id)

    {:ok,
     socket
     |> assign(:correo, correo)
     |> assign(:carrito_id, carrito_id)
     |> assign(:items, items)
     |> assign(:mensaje, nil)}
  end

  def handle_event("confirmar_pago", %{"tarjeta" => datos_tarjeta}, socket) do
    with :ok <- validar_datos(datos_tarjeta),
         {:ok, _} <- Productos.verificar_y_actualizar_stock(socket.assigns.items),
         {:ok, _ventas} <-
           Ventas.mover_items_a_ventas(
             socket.assigns.items,
             socket.assigns.carrito_id,
             socket.assigns.correo
           ),
         {:ok, _} <- Carritos.actualizar_estado_carrito(socket.assigns.carrito_id, "pagado") do
      {:noreply,
       socket
       |> put_flash(:info, "¡Pago realizado con éxito!")
       |> redirect(to: ~p"/")}
    else
      {:error, motivo} ->
        {:noreply, put_flash(socket, :error, motivo)}
    end
  end

  defp validar_datos(%{
         "numero" => num,
         "cvv" => cvv,
         "nombre" => nom,
         "apellido" => ap,
         "vencimiento" => venc
       }) do
    cond do
      String.length(num) != 16 -> {:error, "El número de tarjeta debe tener 16 dígitos."}
      !Regex.match?(~r/^\d+$/, num) -> {:error, "La tarjeta solo debe contener números."}
      String.length(cvv) != 3 or !Regex.match?(~r/^\d+$/, cvv) -> {:error, "CVV inválido."}
      nom == "" or ap == "" -> {:error, "Nombre y apellido son obligatorios."}
      venc < Date.utc_today() |> Date.to_string() -> {:error, "La tarjeta está vencida."}
      true -> :ok
    end
  end
end
