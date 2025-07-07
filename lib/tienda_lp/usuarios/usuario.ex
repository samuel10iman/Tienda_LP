defmodule TiendaLp.Usuarios.Usuario do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:correo, :string, autogenerate: false}
  schema "usuarios" do
    field :nombre, :string
    field :password, :string
    field :saldo, :decimal, default: Decimal.new("0.00")
    field :admin, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(usuario, attrs) do
    usuario
    |> cast(attrs, [:correo, :nombre, :password, :saldo, :admin])
    |> validate_required([:correo, :nombre, :password])
  end
end
