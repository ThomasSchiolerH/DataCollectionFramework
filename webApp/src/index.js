import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

// Use createRoot to manage the root
const container = document.getElementById('root');
const root = createRoot(container); 

// Render within StrictMode for additional checks and warnings in development
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
