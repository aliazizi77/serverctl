#!/bin/bash

BASE_DIR="/opt/serverctl"

source "$BASE_DIR/lib/colors.sh"
source "$BASE_DIR/lib/logger.sh"


COMMAND=$1
SUBCOMMAND=$2

show_help() {
cat <<EOF
Usage: serverctl [command]

Commands:
  site list                 List all Apache sites
  site create <domain>      Create new Apache site

  wp install               Install WordPress on existing site


  db list                   List databases
  db users                  List database users
  db grants                 Show user-database relations
  db create                 Create database and user
  db delete                 Delete database (optionally with user)


  help                      Show this help
EOF
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
  wp)
    source "$BASE_DIR/modules/wp.sh"
  case "$2" in
    install) wp_install ;;
    *)
      echo "Unknown wp command"
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
    delete)
       db_delete
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
