defmodule InventoryHouse.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias InventoryHouse.Repo
  alias InventoryHouse.Items.Item
  alias InventoryHouse.InventoryMovements

  @doc """
  Returns the list of items with their current stock.
  """
  def list_items_with_stock do
    Repo.all(Item)
    |> Enum.map(fn item ->
      %{
        id: item.id,
        name: item.name,
        sku: item.sku,
        unit: item.unit,
        stock: InventoryMovements.calculate_stock(item.id),
        inserted_at: item.inserted_at,
        updated_at: item.updated_at
      }
    end)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.
  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates an item.
  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an item.
  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an item.
  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end
end

