defmodule InventoryHouseWeb.ItemController do
  use InventoryHouseWeb, :controller

  alias InventoryHouse.Items
  alias InventoryHouse.Items.Item

  def index(conn, _params) do
    items = Items.list_items_with_stock()
    json(conn, InventoryHouseWeb.ItemJSON.index(%{items: items}))
  end

  def create(conn, %{"item" => item_params}) do
    case Items.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_status(:created)
        |> json(InventoryHouseWeb.ItemJSON.show(%{item: item}))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(InventoryHouseWeb.ItemJSON.error(%{changeset: changeset}))
    end
  end

  def show(conn, %{"id" => id}) do
    item = Items.get_item!(id)
    stock = InventoryHouse.InventoryMovements.calculate_stock(item.id)
    item_with_stock = %{
      id: item.id,
      name: item.name,
      sku: item.sku,
      unit: item.unit,
      stock: stock,
      inserted_at: item.inserted_at,
      updated_at: item.updated_at
    }
    json(conn, InventoryHouseWeb.ItemJSON.show(%{item: item_with_stock}))
  end
end

