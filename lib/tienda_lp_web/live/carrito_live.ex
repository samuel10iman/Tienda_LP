defmodule TiendaLpWeb.CarritoLive do
  use TiendaLpWeb, :live_view

  def mount(_params, _session, socket) do
    # Ejemplo de productos en el carrito (puedes cambiarlo por tu lógica real)
    carritos = [
      %{producto: %{id: 1, nombre: "Producto 1"}, cantidad: 2, estado: "En carrito"},
      %{producto: %{id: 2, nombre: "Producto 2"}, cantidad: 1, estado: "En carrito"}
    ]
    {:ok, assign(socket, carritos: carritos)}
  end
end