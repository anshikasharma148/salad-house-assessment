defmodule InventoryHouse.InventoryMovementsTest do
  use InventoryHouse.DataCase

  alias InventoryHouse.InventoryMovements
  alias InventoryHouse.Items

  import InventoryHouse.ItemsFixtures

  describe "stock calculation" do
    test "calculate_stock/1 returns zero for item with no movements" do
      item = item_fixture()
      stock = InventoryMovements.calculate_stock(item.id)
      assert Decimal.equal?(stock, Decimal.new(0))
    end

    test "calculate_stock/1 correctly calculates stock with IN movements" do
      item = item_fixture()

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(10),
        movement_type: "IN"
      })

      stock = InventoryMovements.calculate_stock(item.id)
      assert Decimal.equal?(stock, Decimal.new(10))
    end

    test "calculate_stock/1 correctly calculates stock with IN and OUT movements" do
      item = item_fixture()

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(20),
        movement_type: "IN"
      })

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(5),
        movement_type: "OUT"
      })

      stock = InventoryMovements.calculate_stock(item.id)
      assert Decimal.equal?(stock, Decimal.new(15))
    end

    test "calculate_stock/1 correctly calculates stock with ADJUSTMENT movements" do
      item = item_fixture()

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(10),
        movement_type: "IN"
      })

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(3),
        movement_type: "ADJUSTMENT"
      })

      stock = InventoryMovements.calculate_stock(item.id)
      assert Decimal.equal?(stock, Decimal.new(13))
    end

    test "calculate_stock/1 correctly calculates complex stock scenario" do
      item = item_fixture()

      # Stock = sum(IN) - sum(OUT) + sum(ADJUSTMENT)
      # Expected: (10 + 5) - (3 + 2) + (1) = 15 - 5 + 1 = 11

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(10),
        movement_type: "IN"
      })

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(5),
        movement_type: "IN"
      })

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(3),
        movement_type: "OUT"
      })

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(2),
        movement_type: "OUT"
      })

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(1),
        movement_type: "ADJUSTMENT"
      })

      stock = InventoryMovements.calculate_stock(item.id)
      assert Decimal.equal?(stock, Decimal.new(11))
    end
  end

  describe "negative stock validation" do
    test "create_movement/1 rejects OUT movement that would result in negative stock" do
      item = item_fixture()

      result = InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(10),
        movement_type: "OUT"
      })

      assert {:error, %Ecto.Changeset{errors: errors}} = result
      assert {:stock, {"would result in negative stock", []}} in errors
    end

    test "create_movement/1 rejects OUT movement that would result in zero stock" do
      item = item_fixture()

      # Add some stock first
      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(5),
        movement_type: "IN"
      })

      # Try to remove all stock (should be rejected)
      result = InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(5),
        movement_type: "OUT"
      })

      assert {:error, %Ecto.Changeset{errors: errors}} = result
      assert {:stock, {"would result in negative stock", []}} in errors
    end

    test "create_movement/1 allows OUT movement when sufficient stock exists" do
      item = item_fixture()

      # Add stock
      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(10),
        movement_type: "IN"
      })

      # Remove some stock (should succeed)
      assert {:ok, %InventoryHouse.InventoryMovements.InventoryMovement{}} =
        InventoryMovements.create_movement(%{
          item_id: item.id,
          quantity: Decimal.new(5),
          movement_type: "OUT"
        })

      stock = InventoryMovements.calculate_stock(item.id)
      assert Decimal.equal?(stock, Decimal.new(5))
    end

    test "create_movement/1 allows ADJUSTMENT that results in negative stock" do
      item = item_fixture()

      # ADJUSTMENT can go negative (as per requirements, only OUT is restricted)
      result = InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(-10),
        movement_type: "ADJUSTMENT"
      })

      # This should succeed (ADJUSTMENT can be negative)
      assert {:ok, %InventoryHouse.InventoryMovements.InventoryMovement{}} = result
    end
  end

  describe "movement creation" do
    test "create_movement/1 with valid data creates a movement" do
      item = item_fixture()

      valid_attrs = %{
        item_id: item.id,
        quantity: Decimal.new(10),
        movement_type: "IN"
      }

      assert {:ok, %InventoryHouse.InventoryMovements.InventoryMovement{} = movement} =
        InventoryMovements.create_movement(valid_attrs)

      assert movement.item_id == item.id
      assert Decimal.equal?(movement.quantity, Decimal.new(10))
      assert movement.movement_type == "IN"
    end

    test "create_movement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InventoryMovements.create_movement(%{})
    end

    test "get_movement_history/1 returns movements for an item" do
      item = item_fixture()

      InventoryMovements.create_movement(%{
        item_id: item.id,
        quantity: Decimal.new(10),
        movement_type: "IN"
      })

      movements = InventoryMovements.get_movement_history(item.id)
      assert length(movements) == 1
      assert hd(movements).item_id == item.id
    end
  end
end

