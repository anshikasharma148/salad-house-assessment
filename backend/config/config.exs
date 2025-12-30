import Config

config :inventory_house, ecto_repos: [InventoryHouse.Repo]

config :inventory_house, InventoryHouse.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "inventory_house_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :inventory_house, InventoryHouseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "your-secret-key-base-change-this-in-production",
  render_errors: [
    formats: [json: InventoryHouseWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: InventoryHouse.PubSub,
  live_view: [signing_salt: "your-signing-salt"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"

