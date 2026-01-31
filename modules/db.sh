#!/bin/bash

BASE_DIR="/opt/serverctl"
source "$BASE_DIR/lib/logger.sh"
source "$BASE_DIR/lib/colors.sh"

MYSQL="mysql -u root"
MYSQL_CMD="$MYSQL"

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
  read -p "Database name: " DB_NAME
  read -p "Username: " DB_USER

  DB_PASS=$(openssl rand -base64 16)

  $MYSQL_CMD <<EOF
CREATE DATABASE \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

  echo "--------------------------------------"
  echo "Database created successfully ✅"
  echo
  echo "Database : $DB_NAME"
  echo "User     : $DB_USER"
  echo "Password : $DB_PASS"
  echo
  echo "Save this information securely ⚠️"
  echo "--------------------------------------"
}


db_delete() {
  echo "⚠️  WARNING: This action is irreversible"
  echo

  read -p "Database name to delete: " DB_NAME

  if [ -z "$DB_NAME" ]; then
    echo "Database name cannot be empty"
    exit 1
  fi

  DB_EXISTS=$($MYSQL_CMD -N -e "SHOW DATABASES LIKE '${DB_NAME}';")

  if [ -z "$DB_EXISTS" ]; then
    echo "Database '$DB_NAME' does not exist ❌"
    exit 1
  fi

  echo
  echo "Users with access to '$DB_NAME':"
  $MYSQL_CMD -e "
    SELECT DISTINCT User, Host
    FROM mysql.db
    WHERE Db='${DB_NAME}';
  "

  echo
  read -p "Type the database name again to confirm deletion: " CONFIRM

  if [ "$CONFIRM" != "$DB_NAME" ]; then
    echo "Confirmation failed. Aborted ❌"
    exit 1
  fi

  read -p "Delete database '$DB_NAME'? (yes/no): " FINAL_CONFIRM

  if [ "$FINAL_CONFIRM" != "yes" ]; then
    echo "Operation cancelled"
    exit 0
  fi

  $MYSQL_CMD -e "DROP DATABASE \`${DB_NAME}\`;"

  echo "Database '$DB_NAME' deleted ✅"

  echo
  read -p "Do you want to delete a database user as well? (yes/no): " DELETE_USER

  if [ "$DELETE_USER" = "yes" ]; then
    read -p "Username to delete: " DB_USER

    USER_EXISTS=$($MYSQL_CMD -N -e "
      SELECT User FROM mysql.user WHERE User='${DB_USER}';
    ")

    if [ -z "$USER_EXISTS" ]; then
      echo "User '$DB_USER' does not exist ❌"
      exit 0
    fi

    $MYSQL_CMD -e "DROP USER '${DB_USER}'@'localhost'; FLUSH PRIVILEGES;"

    echo "User '$DB_USER' deleted ✅"
  fi
}
