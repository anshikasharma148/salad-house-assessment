import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import MovementForm from '../components/MovementForm';
import './MovementsPage.css';

const MovementsPage: React.FC = () => {
  const navigate = useNavigate();
  const [refreshKey, setRefreshKey] = useState(0);

  const handleRefresh = () => {
    setRefreshKey((prev) => prev + 1);
  };

  return (
    <div className="movements-page">
      <div className="page-header">
        <h1>Record Inventory Movement</h1>
        <button className="back-button" onClick={() => navigate('/')}>
          ← Back to Dashboard
        </button>
      </div>

      <div className="movements-page-content">
        <MovementForm onMovementCreated={handleRefresh} refreshTrigger={refreshKey} />
      </div>
    </div>
  );
};

export default MovementsPage;

