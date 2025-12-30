import Config

# Parse DATABASE_URL if provided, otherwise use individual env vars
database_url = System.get_env("DATABASE_URL")

if database_url do
  # Parse PostgreSQL URL: postgresql://user:password@host:port/database
  config :inventory_house, InventoryHouse.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
else
  config :inventory_house, InventoryHouse.Repo,
    username: System.get_env("DATABASE_USER", "postgres"),
    password: System.get_env("DATABASE_PASS", "postgres"),
    hostname: System.get_env("DATABASE_HOST", "localhost"),
    database: System.get_env("DATABASE_NAME", "inventory_house_prod"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end

config :inventory_house, InventoryHouseWeb.Endpoint,
  http: [
    ip: {0, 0, 0, 0, 0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "prod-secret-key-base-change-in-production"

config :logger, level: :info

