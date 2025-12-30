import React, { useEffect, useState } from 'react';
import { Item, InventoryMovement } from '../types';
import { itemsApi, movementsApi } from '../services/api';
import './ItemDetail.css';

interface ItemDetailProps {
  itemId: number;
  onClose: () => void;
}

const ItemDetail: React.FC<ItemDetailProps> = ({ itemId, onClose }) => {
  const [item, setItem] = useState<Item | null>(null);
  const [movements, setMovements] = useState<InventoryMovement[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadData();
  }, [itemId]);

  const loadData = async () => {
    try {
      setLoading(true);
      const [itemData, movementsData] = await Promise.all([
        itemsApi.getById(itemId),
        movementsApi.getByItemId(itemId),
      ]);
      setItem(itemData);
      setMovements(movementsData);
      setError(null);
    } catch (err) {
      setError('Failed to load item details');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="loading">Loading item details...</div>;
  }

  if (error || !item) {
    return (
      <div className="error">
        {error || 'Item not found'}
        <button onClick={onClose}>Close</button>
      </div>
    );
  }

  return (
    <div className="item-detail">
      <div className="item-info">
        <p><strong>ID:</strong> {item.id}</p>
        <p><strong>Name:</strong> {item.name}</p>
        <p><strong>SKU:</strong> {item.sku}</p>
        <p><strong>Unit:</strong> {item.unit}</p>
        <p><strong>Current Stock:</strong> {item.stock.toFixed(2)} {item.unit}</p>
      </div>

      <div className="movement-history">
        <h3>Movement History</h3>
        {movements.length === 0 ? (
          <p className="empty">No movements recorded</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Quantity</th>
              </tr>
            </thead>
            <tbody>
              {movements.map((movement) => (
                <tr key={movement.id}>
                  <td>{new Date(movement.inserted_at).toLocaleString()}</td>
                  <td className={`movement-type ${movement.movement_type.toLowerCase()}`}>
                    {movement.movement_type}
                  </td>
                  <td>{movement.quantity.toFixed(2)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
};

export default ItemDetail;

