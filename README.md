# Bachelor Project by Andreas Bardram and Thomas Schiøler Hansen

Follow the steps below to set up and run the project.

## Configuration

1. **Set IP Address**:
   - Open the `global_variables.dart` file.
   - Replace the placeholder with your IP address. This is necessary for the login functionality to work correctly.

2. **Create Environment File**:
   - Navigate to the `webApp` folder.
   - Create a file named `.env`.
   - Add the following content to the file:
     ```
     PORT=3001
     REACT_APP_SERVER_URL=http://YourIP:3000
     ```
     Replacing "YourIP" with your machine's IP address

## Running the Server

- To start the server, use the following command:
     ```
     npm run dev
     ```
- This command will start the server in development mode. The server will automatically refresh when changes are made to the code.