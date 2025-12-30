defmodule InventoryHouseWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :inventory_house

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  # CORS origins - support both dev and production
  cors_origins = case System.get_env("MIX_ENV") do
    "prod" ->
      # Production: allow Vercel domain and any custom domain from env
      base_origins = ["https://salad-house-assessment.vercel.app"]
      custom_origin = System.get_env("CORS_ORIGIN")
      if custom_origin, do: base_origins ++ [custom_origin], else: base_origins
    _ ->
      # Development: allow localhost
      ["http://localhost:3000", "http://127.0.0.1:3000"]
  end

  plug CORSPlug,
    origin: cors_origins,
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    headers: ["Content-Type", "Authorization", "Accept"],
    credentials: true

  plug Plug.MethodOverride
  plug Plug.Head

  plug InventoryHouseWeb.Router
end

