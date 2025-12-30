defmodule InventoryHouseWeb.ItemJSON do
  alias InventoryHouse.Items.Item

  def index(%{items: items}) do
    %{data: for(item <- items, do: data(item))}
  end

  def show(%{item: item}) do
    %{data: data(item)}
  end

  defp data(%Item{} = item) do
    stock = InventoryHouse.InventoryMovements.calculate_stock(item.id)
    stock_float = case stock do
      %Decimal{} = d -> Decimal.to_float(d)
      n when is_number(n) -> n
      _ -> 0.0
    end

    %{
      id: item.id,
      name: item.name,
      sku: item.sku,
      unit: item.unit,
      stock: stock_float,
      inserted_at: item.inserted_at,
      updated_at: item.updated_at
    }
  end

  defp data(item) when is_map(item) do
    stock = Map.get(item, :stock, Decimal.new(0))
    stock_float = case stock do
      %Decimal{} = d -> Decimal.to_float(d)
      n when is_number(n) -> n
      _ -> 0.0
    end

    %{
      id: Map.get(item, :id),
      name: Map.get(item, :name),
      sku: Map.get(item, :sku),
      unit: Map.get(item, :unit),
      stock: stock_float,
      inserted_at: Map.get(item, :inserted_at),
      updated_at: Map.get(item, :updated_at)
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

