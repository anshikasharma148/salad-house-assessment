import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import ItemDetail from '../components/ItemDetail';
import './ItemDetailPage.css';

const ItemDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const itemId = id ? parseInt(id, 10) : null;

  if (!itemId) {
    return (
      <div className="item-detail-page">
        <div className="error">Invalid item ID</div>
        <button className="back-button" onClick={() => navigate('/items')}>
          ← Back to Items
        </button>
      </div>
    );
  }

  return (
    <div className="item-detail-page">
      <div className="page-header">
        <h1>Item Details</h1>
        <button className="back-button" onClick={() => navigate('/items')}>
          ← Back to Items
        </button>
      </div>

      <ItemDetail itemId={itemId} onClose={() => navigate('/items')} />
    </div>
  );
};

export default ItemDetailPage;

