<<<<<<< HEAD
# Inventory Management System

A basic Inventory Management System built with Elixir/Phoenix backend and React/TypeScript frontend.

## Tech Stack

- **Backend**: Elixir + Phoenix (JSON API), PostgreSQL
- **Frontend**: React + TypeScript (Create React App)
- **Testing**: ExUnit (backend tests)

## Project Structure

```
salad-house-inventory-house/
├── backend/          # Phoenix application
├── frontend/         # React + TypeScript application
└── README.md         # This file
```

## Data Model

### Items Table

Stores product/item information:

- `id` (integer, primary key)
- `name` (string) - Item name
- `sku` (string, unique) - Stock Keeping Unit identifier
- `unit` (string, enum) - Unit of measurement: "pcs", "kg", or "litre"
- `inserted_at` (datetime) - Creation timestamp
- `updated_at` (datetime) - Last update timestamp

### Inventory Movements Table

Tracks all inventory transactions:

- `id` (integer, primary key)
- `item_id` (integer, foreign key to items) - References the item
- `quantity` (decimal) - Amount of the movement
- `movement_type` (string, enum) - Type of movement: "IN", "OUT", or "ADJUSTMENT"
- `inserted_at` (datetime) - Creation timestamp
- `updated_at` (datetime) - Last update timestamp

### Relationships

- One Item has many Inventory Movements
- Stock is **not stored directly** - it is calculated on-demand

## Stock Calculation Logic

Stock is calculated dynamically using the following formula:

```
Stock = sum(IN movements) - sum(OUT movements) + sum(ADJUSTMENT movements)
```

### Movement Types

- **IN**: Adds to stock (e.g., receiving goods)
- **OUT**: Removes from stock (e.g., sales, consumption)
- **ADJUSTMENT**: Adjusts stock (can be positive or negative, used for corrections)

### Negative Stock Prevention

The system prevents negative stock by validating OUT movements:

- Before creating an OUT movement, the system calculates the current stock
- If the OUT movement would result in negative or zero stock, the operation is rejected
- An error message is returned: "would result in negative stock"
- IN and ADJUSTMENT movements are not restricted (ADJUSTMENT can go negative if needed)

### Example Calculation

Given the following movements for an item:

1. IN: 20 units
2. OUT: 5 units
3. IN: 10 units
4. OUT: 3 units
5. ADJUSTMENT: +2 units

Stock calculation:
- sum(IN) = 20 + 10 = 30
- sum(OUT) = 5 + 3 = 8
- sum(ADJUSTMENT) = 2
- **Stock = 30 - 8 + 2 = 24 units**

## API Endpoints

### Items

- `GET /api/items` - List all items with current stock
- `GET /api/items/:id` - Get a specific item with current stock
- `POST /api/items` - Create a new item
  ```json
  {
    "item": {
      "name": "Product Name",
      "sku": "SKU001",
      "unit": "pcs"
    }
  }
  ```

### Inventory Movements

- `POST /api/inventory_movements` - Record a new inventory movement
  ```json
  {
    "inventory_movement": {
      "item_id": 1,
      "quantity": 10.5,
      "movement_type": "IN"
    }
  }
  ```
- `GET /api/items/:item_id/movements` - Get movement history for an item

## Setup Instructions

### Prerequisites

- Elixir 1.14+ and Erlang/OTP 25+
- PostgreSQL 12+
- Node.js 16+ and npm
- Mix (Elixir build tool)

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   ```

3. Create and setup the database:
   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

4. (Optional) Run seeds:
   ```bash
   mix run priv/repo/seeds.exs
   ```

5. Start the Phoenix server:
   ```bash
   mix phx.server
   ```

The API will be available at `http://localhost:4000`

### Database Configuration

Update database credentials in `backend/config/dev.exs` if needed:

```elixir
config :inventory_house, InventoryHouse.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "inventory_house_dev"
```

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. (Optional) Configure API URL in `.env`:
   ```
   REACT_APP_API_URL=http://localhost:4000/api
   ```

4. Start the development server:
   ```bash
   npm start
   ```

The frontend will be available at `http://localhost:3000`

## Running Tests

### Backend Tests

From the `backend` directory:

```bash
mix test
```

Test coverage includes:
- Stock calculation logic (unit tests)
- Negative stock rejection
- Movement creation with different types
- Item creation and listing

## Assumptions

1. **Stock Units**: All quantities are stored as decimals to support fractional units (e.g., 1.5 kg)
2. **SKU Uniqueness**: SKU must be unique across all items
3. **Unit Types**: Only three unit types are supported: "pcs", "kg", "litre"
4. **Movement Types**: Only three movement types are supported: "IN", "OUT", "ADJUSTMENT"
5. **Negative Stock**: Only OUT movements are restricted from causing negative stock; ADJUSTMENT movements can result in negative stock if needed
6. **Zero Stock**: OUT movements that would result in zero stock are also rejected (treated as negative)
7. **No Authentication**: The system does not include user authentication or authorization
8. **No Soft Deletes**: Items and movements are permanently deleted (no soft delete functionality)

## Future Improvements

1. **Authentication & Authorization**: Add user authentication and role-based access control
2. **Pagination**: Implement pagination for items and movements lists
3. **Filtering & Search**: Add search and filter capabilities for items
4. **Bulk Operations**: Support bulk creation of items and movements
5. **Stock Alerts**: Implement low stock alerts and notifications
6. **Audit Trail**: Enhanced logging and audit trail for all operations
7. **Export/Import**: CSV/Excel export and import functionality
8. **Reports**: Generate inventory reports and analytics
9. **Real-time Updates**: WebSocket support for real-time stock updates
10. **Mobile App**: Native mobile application for inventory management
11. **Barcode Scanning**: Support for barcode/QR code scanning
12. **Multi-warehouse**: Support for multiple warehouse locations
13. **Transaction History**: Enhanced transaction history with more details
14. **Stock Valuation**: Track inventory value and cost calculations
15. **API Documentation**: Swagger/OpenAPI documentation for the API

## License

This project is provided as-is for educational and development purposes.
=======
# Inventory House Frontend

React + TypeScript frontend for the Inventory Management System.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm start
```

The app will run on http://localhost:3000

## Environment Variables

Create a `.env` file in the frontend directory to configure the API URL:

```
REACT_APP_API_URL=http://localhost:4000/api
```
>>>>>>> c8a2783ca2f1d1e567540a7eafb1d42c5adcce4d

