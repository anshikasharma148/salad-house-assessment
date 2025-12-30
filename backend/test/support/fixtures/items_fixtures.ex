defmodule InventoryHouse.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InventoryHouse.Items` context.
  """

  alias InventoryHouse.Items

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        name: "some name",
        sku: "SKU#{System.unique_integer([:positive])}",
        unit: "pcs"
      })
      |> Items.create_item()

    item
  end
end

