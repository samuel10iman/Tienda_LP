defmodule TiendaLp.Repo.Migrations.CrearTablaUsuarios do
  use Ecto.Migration

  def change do
    create table(:usuarios, primary_key: false) do
      add :correo, :string, primary_key: true
      add :nombre, :string, null: false
      add :password, :string, null: false
      add :saldo, :decimal, precision: 10, scale: 2, default: 0.00
      add :admin, :boolean, default: false

      timestamps()
    end
  end
end
