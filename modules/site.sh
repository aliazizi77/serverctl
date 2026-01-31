site_create() {

  echo -e "${CYAN}Create New Apache Website${NC}"
  echo "--------------------------------"

  read -p "Domain name (example.com): " DOMAIN

  if [[ -z "$DOMAIN" ]]; then
    log_error "Domain is required"
    exit 1
  fi

  DEFAULT_ROOT="/var/www/$DOMAIN"
  echo -e "Default document root: ${GREEN}$DEFAULT_ROOT${NC}"

  read -p "Change document root? (y/N): " CHANGE_ROOT

  if [[ "$CHANGE_ROOT" =~ ^[Yy]$ ]]; then
    read -p "Enter custom document root: " WEB_ROOT
  else
    WEB_ROOT="$DEFAULT_ROOT"
  fi

  log_info "Creating document root at $WEB_ROOT"
  mkdir -p "$WEB_ROOT"
  chown -R www-data:www-data "$WEB_ROOT"
  chmod -R 755 "$WEB_ROOT"

  # index.html تستی
  cat > "$WEB_ROOT/index.html" <<EOF
<h1>$DOMAIN</h1>
<p>Apache site created successfully.</p>
EOF

  VHOST_FILE="/etc/apache2/sites-available/$DOMAIN.conf"

  log_info "Creating Apache VirtualHost"

  cat > "$VHOST_FILE" <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $WEB_ROOT

    <Directory $WEB_ROOT>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN-error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN-access.log combined
</VirtualHost>
EOF

  a2ensite "$DOMAIN.conf" >/dev/null
  a2enmod rewrite >/dev/null

  apachectl configtest || exit 1
  systemctl reload apache2

  log_success "Apache site enabled"

  # SSL
  log_info "Issuing SSL certificate"
  certbot --apache -d "$DOMAIN" -d "www.$DOMAIN"

  log_success "SSL enabled successfully"

  echo ""
  echo -e "${GREEN}Site Ready${NC}"
  echo "------------------------------"
  echo "Domain:       $DOMAIN"
  echo "DocumentRoot: $WEB_ROOT"
}

site_list() {
  echo -e "${CYAN}Enabled Apache Sites:${NC}"
  echo "---------------------------"

  for file in /etc/apache2/sites-enabled/*.conf; do
    DOMAIN=$(basename "$file" .conf)
    echo "- $DOMAIN"
  done
}

site_help() {
  echo "Site management:"
  echo ""
  echo "  serverctl site create   Create new Apache site + SSL"
  echo "  serverctl site list     List enabled sites"
}
