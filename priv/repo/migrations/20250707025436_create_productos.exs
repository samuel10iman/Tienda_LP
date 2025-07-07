defmodule TiendaLp.Repo.Migrations.CreateProductos do
  use Ecto.Migration

  def change do
    create table(:productos) do
      add :nombre, :string, null: false
      add :stock, :integer, null: false
      add :precio, :decimal, null: false
      add :imagen, :string
    end
  end
end
