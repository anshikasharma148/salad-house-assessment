defmodule InventoryHouse.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :sku, :string
    field :unit, :string

    has_many :inventory_movements, InventoryHouse.InventoryMovements.InventoryMovement

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :sku, :unit])
    |> validate_required([:name, :sku, :unit])
    |> validate_inclusion(:unit, ["pcs", "kg", "litre"])
    |> unique_constraint(:sku)
  end
end

