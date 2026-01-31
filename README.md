# serverctl

A small shell-based server control utility for managing local and remote services.

## Overview
This repository contains `serverctl.sh`, a lightweight controller script, supporting modules under the `modules/` directory and helper libraries in `lib/`. It provides simple commands to start, stop and check the status of services.

## Prerequisites
- macOS or Linux
- bash

## Quick Start
Make the script executable and show help:

```bash
chmod +x serverctl.sh
./serverctl.sh --help
```

Example commands for the `site` module (if present):

```bash
./serverctl.sh site start
./serverctl.sh site status
./serverctl.sh site stop
```

## Project Structure
- lib/: helper functions and logger
  - colors.sh — output color helpers
  - helpers.sh — shared helper functions
  - logger.sh — simple logging utils
- modules/: functional modules
  - site.sh — example module for managing a website
- serverctl.sh: main entrypoint script

## Adding a New Module
Create a new shell file in `modules/` and implement the `start`, `stop`, and `status` entrypoints. Load the module from `serverctl.sh` following the existing loading pattern.

## Contributing

