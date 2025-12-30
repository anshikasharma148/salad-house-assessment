import React, { useState } from 'react';
import { CreateItemRequest } from '../types';
import { itemsApi } from '../services/api';
import './CreateItemForm.css';

interface CreateItemFormProps {
  onItemCreated?: () => void;
}

const CreateItemForm: React.FC<CreateItemFormProps> = ({ onItemCreated }) => {
  const [formData, setFormData] = useState<CreateItemRequest>({
    name: '',
    sku: '',
    unit: 'pcs',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  // Auto-dismiss success message after 3 seconds
  React.useEffect(() => {
    if (success) {
      const timer = setTimeout(() => {
        setSuccess(false);
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [success]);

  // Auto-dismiss error message after 5 seconds
  React.useEffect(() => {
    if (error) {
      const timer = setTimeout(() => {
        setError(null);
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [error]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccess(false);

    try {
      await itemsApi.create(formData);
      setSuccess(true);
      setFormData({ name: '', sku: '', unit: 'pcs' });
      if (onItemCreated) {
        onItemCreated();
      }
    } catch (err: any) {
      setError(err.response?.data?.errors || 'Failed to create item');
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  return (
    <div className="create-item-form">
      <h2>Create New Item</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">Name:</label>
          <input
            type="text"
            id="name"
            name="name"
            value={formData.name}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="sku">SKU:</label>
          <input
            type="text"
            id="sku"
            name="sku"
            value={formData.sku}
            onChange={handleChange}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="unit">Unit:</label>
          <select
            id="unit"
            name="unit"
            value={formData.unit}
            onChange={handleChange}
            required
          >
            <option value="pcs">Pieces (pcs)</option>
            <option value="kg">Kilograms (kg)</option>
            <option value="litre">Litres (litre)</option>
          </select>
        </div>

        {error && <div className="error-message">{JSON.stringify(error)}</div>}
        {success && <div className="success-message">Item created successfully!</div>}

        <button type="submit" disabled={loading}>
          {loading ? 'Creating...' : 'Create Item'}
        </button>
      </form>
    </div>
  );
};

export default CreateItemForm;

