defmodule InventoryHouse.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InventoryHouse.Repo,
      {Phoenix.PubSub, name: InventoryHouse.PubSub},
      InventoryHouseWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: InventoryHouse.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

