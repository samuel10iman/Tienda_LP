defmodule TiendaLpWeb.Router do
  use TiendaLpWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TiendaLpWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TiendaLpWeb do
    pipe_through :browser

    get "/", PageController, :home
    # live "/carrito", CarritoLive

    get "/productos/new", PageController, :new_producto
    post "/productos", PageController, :create_producto
    get "/productos/show/:id", PageController, :detalle_producto
    get "/productos/edit/:id", PageController, :edit_producto
    put "/productos/:id", PageController, :update_producto
    delete "/productos/:id", PageController, :delete_producto

    get "/perfil", PageController, :perfil
    put "/perfil/editar", PageController, :editar_perfil
    post "/carrito/agregar", CarritoController, :agregar
    get "/carrito", CarritoController, :mostrar

    get "/pasarela_pago", PasarelaPagoController, :mostrar
    post "/confirmar_pago", PasarelaPagoController, :confirmar_pago

  end

  # Other scopes may use custom stacks.
  # scope "/api", TiendaLpWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tienda_lp, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TiendaLpWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
