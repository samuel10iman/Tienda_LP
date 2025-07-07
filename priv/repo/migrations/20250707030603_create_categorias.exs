defmodule TiendaLp.Repo.Migrations.CreateCategorias do
  use Ecto.Migration

  def change do
    create table(:categorias) do
      add :nombre, :string, null: false
    end
  end
end
