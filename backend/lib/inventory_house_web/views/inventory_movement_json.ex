defmodule InventoryHouseWeb.InventoryMovementJSON do
  alias InventoryHouse.InventoryMovements.InventoryMovement

  def index(%{movements: movements}) do
    %{data: for(movement <- movements, do: data(movement))}
  end

  def show(%{movement: movement}) do
    %{data: data(movement)}
  end

  defp data(%InventoryMovement{} = movement) do
    %{
      id: movement.id,
      item_id: movement.item_id,
      quantity: Decimal.to_float(movement.quantity),
      movement_type: movement.movement_type,
      inserted_at: movement.inserted_at,
      updated_at: movement.updated_at
    }
  end

  def error(%{changeset: changeset}) do
    %{
      errors: translate_errors(changeset)
    }
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end

