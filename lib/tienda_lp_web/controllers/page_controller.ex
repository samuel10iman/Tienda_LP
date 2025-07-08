defmodule TiendaLpWeb.PageController do
  use TiendaLpWeb, :controller
  import Phoenix.Component, only: [to_form: 1]

  @moduledoc """
  Your module documentation goes here.
  """

  def home(conn, params) do
    productos = TiendaLp.Productos.buscar_productos(params)
    render(conn, :home, layout: false, productos: productos)
  end

  def new_producto(conn, _params) do
    text(conn, "Formulario para nuevo producto")
  end

  def create_producto(conn, _params) do
    text(conn, "Crear producto")
  end

  def show_producto(conn, %{"id" => id}) do
    text(conn, "Mostrar producto #{id}")
  end

  def edit_producto(conn, %{"id" => id}) do
    text(conn, "Editar producto #{id}")
  end

  def update_producto(conn, %{"id" => id}) do
    text(conn, "Actualizar producto #{id}")
  end

  def delete_producto(conn, %{"id" => id}) do
    text(conn, "Eliminar producto #{id}")
  end

  def perfil(conn, _params) do
    usuario = %{
      nombre: "Gino",
      apellidos: "Díaz",
      celular: "987654321",
      cumpleanios: ~D[2005-07-05],
      edad: 19,
      correo: "ginodiaz7923@gmail.com"
    }

    usuario_form = to_form(usuario)

    render(conn, :perfil,
      layout: false,
      usuario: usuario,
      usuario_form: usuario_form,
      pedidos: [],
      productos: []
    )
  end

  def editar_perfil(conn, usuario_params) do
    usuario = %{
      nombre: usuario_params["nombre"],
      apellidos: usuario_params["apellidos"],
      celular: usuario_params["celular"],
      cumpleanios: usuario_params["cumpleanios"],
      edad: usuario_params["edad"],
      correo: usuario_params["correo"]
    }

    pedidos = []
    productos = []

    usuario_form = to_form(usuario)

    render(conn, :perfil,
      layout: false,
      usuario: usuario,
      usuario_form: usuario_form,
      pedidos: pedidos,
      productos: productos
    )
  end

  def detalle_producto(conn, %{"id" => id}) do
    producto = TiendaLp.Productos.get_producto!(id)

    similares =
      TiendaLp.Productos.listar_productos_similares(producto.categoria_id, producto.id)

    correo = "ginodiaz7923@gmail.com"
    carrito_id = get_session(conn, :carrito_id) || Ecto.UUID.generate()

    conn
    |> put_session(:carrito_id, carrito_id)
    |> render(:detalle_producto,
      layout: false,
      producto: producto,
      similares: similares,
      correo: correo,
      carrito_id: carrito_id
    )
  end
end
