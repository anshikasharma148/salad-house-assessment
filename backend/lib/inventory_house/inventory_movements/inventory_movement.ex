defmodule InventoryHouse.InventoryMovements.InventoryMovement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_movements" do
    field :quantity, :decimal
    field :movement_type, :string

    belongs_to :item, InventoryHouse.Items.Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory_movement, attrs) do
    inventory_movement
    |> cast(attrs, [:item_id, :quantity, :movement_type])
    |> validate_required([:item_id, :quantity, :movement_type])
    |> validate_inclusion(:movement_type, ["IN", "OUT", "ADJUSTMENT"])
    |> validate_number(:quantity, greater_than: 0)
    |> foreign_key_constraint(:item_id)
  end
end

