import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import './App.css';
import Navigation from './components/Navigation';
import Dashboard from './pages/Dashboard';
import ItemsPage from './pages/ItemsPage';
import MovementsPage from './pages/MovementsPage';
import ItemDetailPage from './pages/ItemDetailPage';

function App() {
  return (
    <Router>
      <div className="App">
        <Navigation />
        <main className="App-main">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/items" element={<ItemsPage />} />
            <Route path="/items/:id" element={<ItemDetailPage />} />
            <Route path="/movements" element={<MovementsPage />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;

