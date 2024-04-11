# Bachelor Project by Andreas Bardram and Thomas Schiøler Hansen

## Project Overview

This repository contains the complete source code for a Bachelor's project integrating a Flutter mobile app, a React web app, and a Node.js backend using MongoDB. This setup demonstrates a full-stack application development from the mobile and web frontends to the backend service.

## Prerequisites

Before proceeding, ensure the following software is installed on your system:

- **Node.js** - [Download Node.js](https://nodejs.org/)
- **MongoDB** - [Install MongoDB](https://www.mongodb.com/try/download/community)
- **Flutter** - [Install Flutter](https://flutter.dev/docs/get-started/install)

## Local Development Setup

### Setting Up the Node.js Backend

1. **Clone the repository**
     ```
     git clone https://github.com/ThomasSchiolerH/MentalHealthApp.git
     ```

2. **Navigate to the backend directory**
     ```
     cd server
     ```

3. **Install dependencies**
     ```
     npm install
     ```

4. **Set environment variables**
- Create a `.env` file in the `server` directory.
- Add the following content, replacing mongodb_link with actual link:
  ```
  PORT=3000
  DB="mongodb_link"
  ```

5. **Start the MongoDB server** (if not already running)


6. **Run the backend server**
  ```
  npm run dev
  ```

### Setting Up the React Web App

1. **Navigate to the web application directory**
  ```
  cd ../webApp
  ```

2. **Install dependencies**
  ```
  npm install
  ```

3. **Configure environment variables**
- Create a `.env` file in the `server` directory.
- Add the following content, replacing your_IP with your current IP address.
  ```
  PORT=3001
  REACT_APP_SERVER_URL=http://your_IP:3000
  ```

4. **Start the development server**
  ```
  npm start
  ```

- Access the web app at `http://localhost:3001`.

### Setting Up the Flutter Mobile App

1. **Navigate to the Flutter app directory**
  ```
  cd ../App
  ```

2. **Set IP Address**
- Open `global_variables.dart`.
- Replace the IP address placeholder with your local machine's IP to ensure proper connectivity with the backend.

3. **Run the Flutter app**
- Ensure your device or emulator is operational.
- Execute:
  ```
  flutter run
  ```

## Usage

- **React Web App**: Visit `http://localhost:3001` to view the web application.
- **Node.js Backend**: The backend APIs are served at `http://localhost:3000`.
- **Flutter App**: Run on your connected device or emulator via the Flutter command.







     ```
     npm run dev
     ```
- This command will start the server in development mode. The server will automatically refresh when changes are made to the code.