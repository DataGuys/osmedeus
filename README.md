# Osmedeus Framework

Osmedeus is an advanced reconnaissance and vulnerability scanning framework designed for security professionals and penetration testers.

## Features

- Automated reconnaissance workflow
- Modular architecture for easy extension
- Comprehensive scanning capabilities
- Intuitive dashboard for visualizing results
- Advanced reporting options

## Installation

### Prerequisites
- Python 3.8+
- Docker (optional but recommended)
- Go 1.16+ (for certain modules)

### Quick Install
```bash
git clone https://github.com/DataGuys/osmedeus.git
cd osmedeus
./install.sh
```

// filepath: osmedeus-scanner/README.md
# Osmedeus Scanner

Modular external scanner and pen testing tool.

## Prerequisites

- Node.js (v20 or later recommended)
- npm
- Docker (for containerized deployment)

## Development

1.  **Install dependencies:**
    ```bash
    npm install
    ```

2.  **Run in development mode (with auto-recompilation):**
    ```bash
    npm run dev
    ```

## Build for Production

1.  **Compile TypeScript to JavaScript:**
    ```bash
    npm run build
    ```
    This will output files to the `dist` directory.

## Running in Production

1.  **Start the application:**
    ```bash
    npm start
    ```
    This runs the compiled code from the `dist` directory.

## Docker Deployment

1.  **Build the Docker image:**
    ```bash
    docker build -t osmedeus-scanner .
    ```

2.  **Run the Docker container:**
    ```bash
    docker run -p 3000:3000 osmedeus-scanner
    ```
    The application inside the container will be accessible on port 3000 of your host machine.

## Project Structure

- `src/`: Contains the TypeScript source code.
  - `core/`: Core scanning logic.
  - `interfaces/`: TypeScript interfaces for modules, targets, and results.
  - `modules/`: Individual scan modules. Each module should implement the `IScanModule` interface.
    - `telerik_checker/`: Example module for Telerik vulnerabilities.
    - `web_config_analyzer/`: Example module for web.config analysis.
  - `utils/`: Utility functions (e.g., logger).
  - `config/`: Configuration management.
  - `index.ts`: Main entry point of the application.
- `dist/`: Contains the compiled JavaScript code (after running `npm run build`).
- `Dockerfile`: For building the Docker image.
- `package.json`: Project metadata and dependencies.
- `tsconfig.json`: TypeScript compiler options.

## Adding New Scan Modules

1.  Create a new directory under `src/modules/your_module_name/`.
2.  Create an `index.ts` file in that directory.
3.  Implement the `IScanModule` interface from `src/interfaces/IScanModule.ts`.
4.  Export your module class.
5.  The main scanner logic in `src/core/scanner.ts` can be updated to discover and load modules dynamically or explicitly.