defmodule TiendaLp.Categorias.Categoria do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categorias" do
    field :nombre, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(categoria, attrs) do
    categoria
    |> cast(attrs, [:nombre])
    |> validate_required([:nombre])
  end
end
