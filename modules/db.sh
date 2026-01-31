#!/bin/bash

BASE_DIR="/opt/serverctl"
source "$BASE_DIR/lib/logger.sh"
source "$BASE_DIR/lib/colors.sh"

MYSQL="mysql -u root"

db_list() {
  echo -e "${CYAN}Databases:${NC}"
  echo "---------------------"
  $MYSQL -e "SHOW DATABASES;"
}

db_users() {
  echo -e "${CYAN}Database Users:${NC}"
  echo "---------------------"
  $MYSQL -e "SELECT User, Host FROM mysql.user;"
}

db_grants() {
  read -p "Database user: " DBUSER
  $MYSQL -e "SHOW GRANTS FOR '$DBUSER'@'localhost';"
}

db_create() {

  read -p "Database name: " DBNAME
  read -p "Username: " DBUSER
  read -s -p "Password: " DBPASS
  echo ""

  echo -e "${YELLOW}Grant level?${NC}"
  echo "1) FULL (ALL PRIVILEGES)"
  echo "2) LIMITED (SELECT, INSERT, UPDATE, DELETE)"
  read -p "Choice [1/2]: " LEVEL

  if [[ "$LEVEL" == "1" ]]; then
    PRIVS="ALL PRIVILEGES"
  else
    PRIVS="SELECT,INSERT,UPDATE,DELETE"
  fi

  $MYSQL <<EOF
CREATE DATABASE IF NOT EXISTS \`$DBNAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';
GRANT $PRIVS ON \`$DBNAME\`.* TO '$DBUSER'@'localhost';
FLUSH PRIVILEGES;
EOF

  log_success "Database $DBNAME created"
  log_success "User $DBUSER connected"
}
