defmodule InventoryHouse.ItemsTest do
  use InventoryHouse.DataCase

  alias InventoryHouse.Items

  describe "items" do
    alias InventoryHouse.Items.Item

    import InventoryHouse.ItemsFixtures

    test "list_items_with_stock/0 returns all items with calculated stock" do
      item = item_fixture()
      assert [%Item{} = listed_item] = Items.list_items_with_stock()
      assert listed_item.id == item.id
      assert listed_item.stock == Decimal.new(0)
    end

    test "create_item/1 with valid data creates an item" do
      valid_attrs = %{name: "Test Item", sku: "SKU001", unit: "pcs"}

      assert {:ok, %Item{} = item} = Items.create_item(valid_attrs)
      assert item.name == "Test Item"
      assert item.sku == "SKU001"
      assert item.unit == "pcs"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(%{})
    end

    test "create_item/1 with duplicate SKU returns error" do
      valid_attrs = %{name: "Test Item", sku: "SKU001", unit: "pcs"}
      assert {:ok, %Item{}} = Items.create_item(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Items.create_item(valid_attrs)
    end

    test "create_item/1 with invalid unit returns error" do
      invalid_attrs = %{name: "Test Item", sku: "SKU001", unit: "invalid"}
      assert {:error, %Ecto.Changeset{}} = Items.create_item(invalid_attrs)
    end
  end
end

