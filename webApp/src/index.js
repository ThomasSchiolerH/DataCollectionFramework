import React from 'react';
import { createRoot } from 'react-dom/client'; // Import createRoot
import App from './App';

// Use createRoot to manage the root of your app
const container = document.getElementById('root');
const root = createRoot(container); // Create a root instance

// Render your app within StrictMode for additional checks and warnings in development
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
