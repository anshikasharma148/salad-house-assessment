defmodule InventoryHouse.Repo.Migrations.CreateInventoryMovements do
  use Ecto.Migration

  def change do
    create table(:inventory_movements) do
      add :item_id, references(:items, on_delete: :delete_all), null: false
      add :quantity, :decimal, precision: 10, scale: 2, null: false
      add :movement_type, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:inventory_movements, [:item_id])
    create index(:inventory_movements, [:inserted_at])
  end
end

