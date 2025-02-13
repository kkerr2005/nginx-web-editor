# Nginx Web Editor

This project provides a web front end for editing Nginx load balancing configurations on a Linux server. It utilizes Pode.Web to create a user-friendly interface for managing Nginx settings.

## Project Structure

- **src/public/index.html**: The main HTML file serving as the entry point for the user interface.
- **src/public/css/styles.css**: Contains styles for the web front end, defining layout and appearance.
- **src/public/js/script.js**: Handles user interactions and requests to the backend for editing Nginx configurations.
- **src/lib/NginxUtils.psm1**: PowerShell module with utility functions for managing Nginx configurations.
- **src/modules/config_module.psm1**: Contains logic for handling configuration requests from the web front end.
- **src/themes/default.psd1**: Defines default theme settings for the Pode.Web application.
- **src/PodeWeb.ps1**: Main entry point for the Pode.Web application, setting up the web server and routes.
- **src/types/index.ts**: TypeScript file defining types and interfaces for type safety in JavaScript code.
- **.vscode/settings.json**: Development environment settings, including formatting options and extensions.
- **README.md**: Documentation for setup instructions, usage guidelines, and relevant information.
- **nginx-web-editor.psd1**: Module manifest defining metadata, exported functions, and dependencies.

## Setup Instructions

1. Clone the repository to your local machine.
2. Navigate to the project directory.
3. Ensure you have the necessary dependencies installed for Pode.Web.
4. Run the main entry point script (`src/PodeWeb.ps1`) to start the web server.
5. Access the web interface through your browser to manage Nginx configurations.

## Usage Guidelines

- Use the web interface to edit Nginx load balancing settings.
- Changes made through the interface will be reflected in the Nginx configuration files on the server.
- Ensure you have the appropriate permissions to modify Nginx configurations.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.