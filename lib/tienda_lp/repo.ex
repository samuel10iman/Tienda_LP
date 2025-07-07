defmodule TiendaLp.Repo do
  use Ecto.Repo,
    otp_app: :tienda_lp,
    adapter: Ecto.Adapters.Postgres
end
