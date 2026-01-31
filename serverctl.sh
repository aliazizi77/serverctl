#!/bin/bash

BASE_DIR="/opt/serverctl"

source "$BASE_DIR/lib/colors.sh"
source "$BASE_DIR/lib/logger.sh"

COMMAND=$1
SUBCOMMAND=$2

show_help() {
  echo "ServerCTL - Personal Server Manager"
  echo ""
  echo "Usage:"
  echo "  serverctl <command> <subcommand>"
  echo ""
  echo "Commands:"
  echo "  site        Website management (Apache)"
  echo "  db          Database management (MySQL/MariaDB)"
  echo "  help        Show this help"
  echo ""
  echo "Examples:"
  echo "  serverctl site create"
  echo "  serverctl site list"
  echo "  serverctl db list"
}


case "$COMMAND" in
  site)
    source "$BASE_DIR/modules/site.sh"
    case "$SUBCOMMAND" in
      create)
        site_create
        ;;
      list)
        site_list
        ;;
      help|"")
        site_help
        ;;
      *)
        log_error "Unknown site command"
        ;;
    esac
    ;;
  help|"")
    show_help
    ;;
  db)
  source "$BASE_DIR/modules/db.sh"
  case "$SUBCOMMAND" in
    list)
      db_list
      ;;
    users)
      db_users
      ;;
    grants)
      db_grants
      ;;
    create)
      db_create
      ;;
    help|"")
      db_help
      ;;
    *)
      log_error "Unknown db command"
      ;;
  esac
  ;;
  *)
    log_error "Unknown command"
    show_help
    ;;
esac
