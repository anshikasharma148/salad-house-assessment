defmodule InventoryHouseWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :inventory_house

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug CORSPlug,
    origin: ["http://localhost:3000", "http://127.0.0.1:3000"],
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    headers: ["Content-Type", "Authorization", "Accept"],
    credentials: true

  plug Plug.MethodOverride
  plug Plug.Head

  plug InventoryHouseWeb.Router
end

