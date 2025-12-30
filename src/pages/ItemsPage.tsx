import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import ItemList from '../components/ItemList';
import CreateItemForm from '../components/CreateItemForm';
import './ItemsPage.css';

const ItemsPage: React.FC = () => {
  const navigate = useNavigate();
  const [refreshKey, setRefreshKey] = useState(0);

  const handleRefresh = () => {
    setRefreshKey((prev) => prev + 1);
  };

  const handleItemClick = (itemId: number) => {
    navigate(`/items/${itemId}`);
  };

  return (
    <div className="items-page">
      <div className="page-header">
        <h1>Items Management</h1>
        <button className="back-button" onClick={() => navigate('/')}>
          ← Back to Dashboard
        </button>
      </div>

      <div className="items-page-content">
        <div className="items-page-form">
          <CreateItemForm onItemCreated={handleRefresh} />
        </div>

        <div className="items-page-list">
          <ItemList key={refreshKey} onItemClick={handleItemClick} />
        </div>
      </div>
    </div>
  );
};

export default ItemsPage;

