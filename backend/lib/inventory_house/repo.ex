defmodule InventoryHouse.Repo do
  use Ecto.Repo,
    otp_app: :inventory_house,
    adapter: Ecto.Adapters.Postgres
end

