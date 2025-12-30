import axios from 'axios';
import { Item, InventoryMovement, CreateItemRequest, CreateMovementRequest } from '../types';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:4000/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const itemsApi = {
  getAll: async (): Promise<Item[]> => {
    const response = await api.get<{ data: Item[] }>('/items');
    return response.data.data;
  },

  getById: async (id: number): Promise<Item> => {
    const response = await api.get<{ data: Item }>(`/items/${id}`);
    return response.data.data;
  },

  create: async (item: CreateItemRequest): Promise<Item> => {
    const response = await api.post<{ data: Item }>('/items', { item });
    return response.data.data;
  },
};

export const movementsApi = {
  getByItemId: async (itemId: number): Promise<InventoryMovement[]> => {
    const response = await api.get<{ data: InventoryMovement[] }>(`/items/${itemId}/movements`);
    return response.data.data;
  },

  create: async (movement: CreateMovementRequest): Promise<InventoryMovement> => {
    const response = await api.post<{ data: InventoryMovement }>('/inventory_movements', {
      inventory_movement: movement,
    });
    return response.data.data;
  },
};

