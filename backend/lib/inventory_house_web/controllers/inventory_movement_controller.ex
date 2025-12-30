defmodule InventoryHouseWeb.InventoryMovementController do
  use InventoryHouseWeb, :controller

  alias InventoryHouse.InventoryMovements
  alias InventoryHouse.InventoryMovements.InventoryMovement

  def create(conn, %{"inventory_movement" => movement_params}) do
    case InventoryMovements.create_movement(movement_params) do
      {:ok, movement} ->
        conn
        |> put_status(:created)
        |> json(InventoryHouseWeb.InventoryMovementJSON.show(%{movement: movement}))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(InventoryHouseWeb.InventoryMovementJSON.error(%{changeset: changeset}))
    end
  end

  def index(conn, %{"item_id" => item_id}) do
    movements = InventoryMovements.get_movement_history(item_id)
    json(conn, InventoryHouseWeb.InventoryMovementJSON.index(%{movements: movements}))
  end
end

