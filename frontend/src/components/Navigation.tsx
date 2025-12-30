import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import './Navigation.css';

const Navigation: React.FC = () => {
  const location = useLocation();

  return (
    <nav className="navigation">
      <div className="nav-brand">
        <Link to="/">Inventory System</Link>
      </div>
      <div className="nav-links">
        <Link 
          to="/" 
          className={location.pathname === '/' ? 'active' : ''}
        >
          Dashboard
        </Link>
        <Link 
          to="/items" 
          className={location.pathname.startsWith('/items') ? 'active' : ''}
        >
          Items
        </Link>
        <Link 
          to="/movements" 
          className={location.pathname === '/movements' ? 'active' : ''}
        >
          Movements
        </Link>
      </div>
    </nav>
  );
};

export default Navigation;

