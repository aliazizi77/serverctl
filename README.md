# ServerCTL

ServerCTL is a lightweight, open-source CLI tool for managing Linux servers. It is designed for personal and multi-server use, focusing on simplicity, transparency, and extensibility.

Currently supported:

- Apache website management
- MySQL/MariaDB database management

The project is written in Bash and works on **Ubuntu 24.04**.

---

## Features

### Website Management (Apache)

- Create new Apache VirtualHost
- Auto-create document root
- Enable site
- Issue SSL certificates via Let’s Encrypt
- List enabled sites

### Database Management (MySQL/MariaDB)

- List databases
- List database users
- View user–database permissions (grants)
- Create database and user
- Assign permissions

---

## Installation

### 1. Clone the repository

```bash
sudo mkdir -p /opt
cd /opt
sudo git clone https://github.com/YOUR_USERNAME/serverctl.git
cd serverctl
sudo chmod +x serverctl.sh
```

### 2. Add `serverctl` to PATH

```bash
sudo ln -s /opt/serverctl/serverctl.sh /usr/local/bin/serverctl
```

Verify installation:

```bash
serverctl help
```

---

## Requirements

- Ubuntu 24.04
- Apache 2
- MySQL or MariaDB
- Certbot (for SSL)

Install required packages:

```bash
sudo apt update
sudo apt install -y apache2 mysql-client certbot python3-certbot-apache
```

---

## Usage

### Global Help

```bash
serverctl help
```

---

## Site Management

### Create a new site

```bash
serverctl site create
```

### List enabled sites

```bash
serverctl site list
```

### Site help

```bash
serverctl site help
```

---

## Database Management

### List databases

```bash
serverctl db list
```

### List database users

```bash
serverctl db users
```

### Show user permissions

```bash
serverctl db grants
```

### Create database and user

```bash
serverctl db create
```

### Database help

```bash
serverctl db help
```

---

## Project Structure

```
serverctl/
├── serverctl.sh
├── modules/
│   ├── site.sh
│   └── db.sh
├── lib/
│   ├── logger.sh
│   └── colors.sh
└── README.md
```

---

## Roadmap

Planned features:

- Database backup & restore
- Site–database linking
- WordPress automation
- PHP version management
- Firewall & security tools
- Multi-server profiles

---

## License

MIT License

---

## Philosophy

ServerCTL is intentionally simple. No hidden magic, no heavy dependencies — just readable scripts that you control.

