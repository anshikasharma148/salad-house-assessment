export type MovementType = "IN" | "OUT" | "ADJUSTMENT";

export interface Item {
  id: number;
  name: string;
  sku: string;
  unit: "pcs" | "kg" | "litre";
  stock: number;
  inserted_at: string;
  updated_at: string;
}

export interface InventoryMovement {
  id: number;
  item_id: number;
  quantity: number;
  movement_type: MovementType;
  inserted_at: string;
  updated_at: string;
}

export interface CreateItemRequest {
  name: string;
  sku: string;
  unit: "pcs" | "kg" | "litre";
}

export interface CreateMovementRequest {
  item_id: number;
  quantity: number;
  movement_type: MovementType;
}

