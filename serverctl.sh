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
  echo "  site create     Create new website (Apache)"
  echo "  site list       List all websites"
  echo "  help            Show this help"
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
  *)
    log_error "Unknown command"
    show_help
    ;;
esac
