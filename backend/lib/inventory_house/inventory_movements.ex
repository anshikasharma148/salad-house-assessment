defmodule InventoryHouse.InventoryMovements do
  @moduledoc """
  The InventoryMovements context.
  """

  import Ecto.Query, warn: false
  alias InventoryHouse.Repo
  alias InventoryHouse.InventoryMovements.InventoryMovement

  @doc """
  Calculates the current stock for an item.
  Stock = sum(IN) - sum(OUT) + sum(ADJUSTMENT)
  """
  def calculate_stock(item_id) do
    movements = Repo.all(
      from m in InventoryMovement,
      where: m.item_id == ^item_id,
      select: {m.movement_type, m.quantity}
    )

    {in_sum, out_sum, adjustment_sum} =
      Enum.reduce(movements, {Decimal.new(0), Decimal.new(0), Decimal.new(0)}, fn
        {"IN", quantity}, {in_acc, out_acc, adj_acc} ->
          {Decimal.add(in_acc, quantity), out_acc, adj_acc}

        {"OUT", quantity}, {in_acc, out_acc, adj_acc} ->
          {in_acc, Decimal.add(out_acc, quantity), adj_acc}

        {"ADJUSTMENT", quantity}, {in_acc, out_acc, adj_acc} ->
          {in_acc, out_acc, Decimal.add(adj_acc, quantity)}
      end)

    # Stock = sum(IN) - sum(OUT) + sum(ADJUSTMENT)
    Decimal.sub(in_sum, out_sum)
    |> Decimal.add(adjustment_sum)
  end

  @doc """
  Returns the list of inventory_movements for an item.
  """
  def get_movement_history(item_id) do
    Repo.all(
      from m in InventoryMovement,
      where: m.item_id == ^item_id,
      order_by: [desc: m.inserted_at],
      preload: [:item]
    )
  end

  @doc """
  Gets a single inventory_movement.

  Raises `Ecto.NoResultsError` if the Inventory movement does not exist.
  """
  def get_inventory_movement!(id), do: Repo.get!(InventoryMovement, id)

  @doc """
  Creates an inventory movement with negative stock validation.
  """
  def create_movement(attrs \\ %{}) do
    changeset = InventoryMovement.changeset(%InventoryMovement{}, attrs)

    if changeset.valid? do
      item_id = Ecto.Changeset.get_field(changeset, :item_id)
      movement_type = Ecto.Changeset.get_field(changeset, :movement_type)
      quantity = Ecto.Changeset.get_field(changeset, :quantity)

      # Calculate current stock
      current_stock = calculate_stock(item_id)

      # Check if this movement would result in negative stock
      new_stock = case movement_type do
        "IN" -> Decimal.add(current_stock, quantity)
        "OUT" -> Decimal.sub(current_stock, quantity)
        "ADJUSTMENT" -> Decimal.add(current_stock, quantity)
      end

      if Decimal.negative?(new_stock) or (Decimal.equal?(new_stock, Decimal.new(0)) and movement_type == "OUT") do
        {:error, %{changeset | errors: [stock: {"would result in negative stock", []}]}}
      else
        Repo.insert(changeset)
      end
    else
      {:error, changeset}
    end
  end

  @doc """
  Updates an inventory_movement.
  """
  def update_inventory_movement(%InventoryMovement{} = inventory_movement, attrs) do
    inventory_movement
    |> InventoryMovement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an inventory_movement.
  """
  def delete_inventory_movement(%InventoryMovement{} = inventory_movement) do
    Repo.delete(inventory_movement)
  end
end

