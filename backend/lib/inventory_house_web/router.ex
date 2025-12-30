defmodule InventoryHouseWeb.Router do
  use InventoryHouseWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", InventoryHouseWeb do
    pipe_through :api

    resources "/items", ItemController, except: [:new, :edit] do
      get "/movements", InventoryMovementController, :index
    end

    resources "/inventory_movements", InventoryMovementController, only: [:create]
  end
end

