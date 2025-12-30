import React, { useState, useEffect } from 'react';
import { CreateMovementRequest, Item, MovementType } from '../types';
import { movementsApi, itemsApi } from '../services/api';
import './MovementForm.css';

interface MovementFormProps {
  onMovementCreated?: () => void;
  refreshTrigger?: number;
}

const MovementForm: React.FC<MovementFormProps> = ({ onMovementCreated, refreshTrigger }) => {
  const [items, setItems] = useState<Item[]>([]);
  const [formData, setFormData] = useState<CreateMovementRequest>({
    item_id: 0,
    quantity: 0,
    movement_type: 'IN',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  useEffect(() => {
    loadItems();
  }, [refreshTrigger]);

  // Auto-dismiss success message after 3 seconds
  useEffect(() => {
    if (success) {
      const timer = setTimeout(() => {
        setSuccess(false);
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [success]);

  // Auto-dismiss error message after 5 seconds
  useEffect(() => {
    if (error) {
      const timer = setTimeout(() => {
        setError(null);
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [error]);

  const loadItems = async () => {
    try {
      const data = await itemsApi.getAll();
      setItems(data);
      if (data.length > 0 && formData.item_id === 0) {
        setFormData((prev) => ({ ...prev, item_id: data[0].id }));
      }
    } catch (err) {
      console.error('Failed to load items:', err);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccess(false);

    try {
      await movementsApi.create(formData);
      setSuccess(true);
      setFormData((prev) => ({ ...prev, quantity: 0 }));
      // Reload items to update stock values
      await loadItems();
      if (onMovementCreated) {
        onMovementCreated();
      }
    } catch (err: any) {
      const errorMessage = err.response?.data?.errors || 'Failed to create movement';
      setError(typeof errorMessage === 'string' ? errorMessage : JSON.stringify(errorMessage));
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: name === 'item_id' || name === 'quantity' ? Number(value) : value,
    }));
  };

  return (
    <div className="movement-form">
      <h2>Record Inventory Movement</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="item_id">Item:</label>
          <select
            id="item_id"
            name="item_id"
            value={formData.item_id}
            onChange={handleChange}
            required
          >
            <option value={0}>Select an item</option>
            {items.map((item) => (
              <option key={item.id} value={item.id}>
                {item.name} (SKU: {item.sku}) - Stock: {item.stock.toFixed(2)} {item.unit}
              </option>
            ))}
          </select>
        </div>

        <div className="form-group">
          <label htmlFor="movement_type">Movement Type:</label>
          <select
            id="movement_type"
            name="movement_type"
            value={formData.movement_type}
            onChange={handleChange}
            required
          >
            <option value="IN">IN (Add stock)</option>
            <option value="OUT">OUT (Remove stock)</option>
            <option value="ADJUSTMENT">ADJUSTMENT (Adjust stock)</option>
          </select>
        </div>

        <div className="form-group">
          <label htmlFor="quantity">Quantity:</label>
          <input
            type="number"
            id="quantity"
            name="quantity"
            value={formData.quantity || ''}
            onChange={handleChange}
            min="0.01"
            step="0.01"
            required
          />
        </div>

        {error && <div className="error-message">{error}</div>}
        {success && <div className="success-message">Movement recorded successfully!</div>}

        <button type="submit" disabled={loading || formData.item_id === 0}>
          {loading ? 'Recording...' : 'Record Movement'}
        </button>
      </form>
    </div>
  );
};

export default MovementForm;

