#!/bin/bash

source /opt/serverctl/lib/logger.sh

wp_install() {

  echo "WordPress Auto Installer"
  echo "------------------------"

  echo "Available Apache sites:"
  ls /etc/apache2/sites-enabled | sed 's/.conf//'

  echo
  read -p "Select domain: " DOMAIN

  DOC_ROOT=$(grep -R "ServerName $DOMAIN" /etc/apache2/sites-enabled | \
    awk '{print $NF}')

  if [ -z "$DOC_ROOT" ]; then
    log_error "Domain not found"
    exit 1
  fi

  log_info "Document root: $DOC_ROOT"

  if [ "$(ls -A $DOC_ROOT)" ]; then
    read -p "Directory not empty. Continue? (yes/no): " CONFIRM
    [ "$CONFIRM" != "yes" ] && exit 1
  fi

  cd /tmp || exit 1

  log_info "Downloading WordPress..."
  wget -q https://fa.wordpress.org/latest-fa_IR.zip

  tar -xzf latest.tar.gz
  cp -r wordpress/* "$DOC_ROOT"

  rm -rf wordpress latest.tar.gz

  log_success "WordPress files deployed"

  echo
  read -p "Database name: " DB_NAME
  read -p "Database user: " DB_USER
  DB_PASS=$(openssl rand -base64 16)

  mysql -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4;"
  mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
  mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"

  log_success "Database created"

  cp "$DOC_ROOT/wp-config-sample.php" "$DOC_ROOT/wp-config.php"

  sed -i "s/database_name_here/${DB_NAME}/" "$DOC_ROOT/wp-config.php"
  sed -i "s/username_here/${DB_USER}/" "$DOC_ROOT/wp-config.php"
  sed -i "s/password_here/${DB_PASS}/" "$DOC_ROOT/wp-config.php"

  SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

  sed -i "/AUTH_KEY/d;/SECURE_AUTH_KEY/d;/LOGGED_IN_KEY/d;/NONCE_KEY/d;\
/AUTH_SALT/d;/SECURE_AUTH_SALT/d;/LOGGED_IN_SALT/d;/NONCE_SALT/d" \
"$DOC_ROOT/wp-config.php"

  sed -i "/#@-/r /dev/stdin" "$DOC_ROOT/wp-config.php" <<< "$SALTS"

  chown -R www-data:www-data "$DOC_ROOT"
  find "$DOC_ROOT" -type d -exec chmod 755 {} \;
  find "$DOC_ROOT" -type f -exec chmod 644 {} \;

  log_success "wp-config.php generated"

  echo
  echo "--------------------------------"
  echo "WordPress Installed Successfully"
  echo "--------------------------------"
  echo "URL: https://$DOMAIN"
  echo "Database: $DB_NAME"
  echo "User: $DB_USER"
  echo "Password: $DB_PASS"
  echo
}
