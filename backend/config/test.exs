import Config

config :inventory_house, InventoryHouse.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "inventory_house_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :inventory_house, InventoryHouseWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test-secret-key-base-for-testing-only",
  server: false

config :logger, level: :warning

