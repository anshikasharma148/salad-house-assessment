import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { itemsApi } from '../services/api';
import { Item } from '../types';
import './Dashboard.css';

const Dashboard: React.FC = () => {
  const navigate = useNavigate();
  const [items, setItems] = useState<Item[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadItems();
  }, []);

  const loadItems = async () => {
    try {
      const data = await itemsApi.getAll();
      setItems(data);
    } catch (err) {
      console.error('Failed to load items:', err);
    } finally {
      setLoading(false);
    }
  };

  const totalItems = items.length;
  const totalStock = items.reduce((sum, item) => sum + item.stock, 0);
  const lowStockItems = items.filter(item => item.stock < 10).length;

  return (
    <div className="dashboard">
      <h1>Dashboard</h1>
      
      <div className="dashboard-stats">
        <div className="stat-card" onClick={() => navigate('/items')}>
          <div className="stat-value">{totalItems}</div>
          <div className="stat-label">Total Items</div>
        </div>
        
        <div className="stat-card" onClick={() => navigate('/items')}>
          <div className="stat-value">{totalStock.toFixed(2)}</div>
          <div className="stat-label">Total Stock</div>
        </div>
        
        <div className="stat-card" onClick={() => navigate('/items')}>
          <div className="stat-value">{lowStockItems}</div>
          <div className="stat-label">Low Stock Items</div>
        </div>
      </div>

      <div className="dashboard-actions">
        <button className="action-button" onClick={() => navigate('/items')}>
          Manage Items
        </button>
        <button className="action-button" onClick={() => navigate('/movements')}>
          Record Movement
        </button>
      </div>

      {!loading && items.length > 0 && (
        <div className="dashboard-recent">
          <h2>Recent Items</h2>
          <div className="recent-items">
            {items.slice(0, 5).map((item) => (
              <div 
                key={item.id} 
                className="recent-item"
                onClick={() => navigate(`/items/${item.id}`)}
              >
                <div className="recent-item-name">{item.name}</div>
                <div className="recent-item-stock">{item.stock.toFixed(2)} {item.unit}</div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default Dashboard;

