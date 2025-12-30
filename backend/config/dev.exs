import Config

config :inventory_house, InventoryHouse.Repo,
  username: "postgres",
  password: "root",
  hostname: "localhost",
  database: "inventory_house_dev",
  pool_size: 10,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :inventory_house, InventoryHouseWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "dev-secret-key-base-change-in-production",
  watchers: []

