#!/bin/sh
# Capibara Colonial Marines - Docker entrypoint.
#
# Precedence reminder (weakest to strongest):
#   ConfigPresets/*.toml (defaults) < server_config.toml < ROBUST_CVARS env < --cvar here
# Anything not covered by the SS14_* variables below is reachable from Dokploy via
# ROBUST_CVARS="key=value;key=value" with no code change and no rebuild.
set -e

# Base args: baked config + persistent data dir on the volume.
set -- --config-file /app/server_config.toml --data-dir /data

# Always-on hardening (defense in depth; also set in the TOML). Behind Docker and a
# reverse proxy, "loopback" is the container or Traefik, never the operator. Forced
# here at --cvar level so no ROBUST_CVAR_* can re-enable it.
set -- "$@" --cvar "console.loginlocal=false"

# Optional per-deploy overrides.
[ -n "$SS14_HOSTNAME" ]      && set -- "$@" --cvar "game.hostname=$SS14_HOSTNAME"
[ -n "$SS14_HUB_ADVERTISE" ] && set -- "$@" --cvar "hub.advertise=$SS14_HUB_ADVERTISE"
[ -n "$SS14_AUTH_MODE" ]     && set -- "$@" --cvar "auth.mode=$SS14_AUTH_MODE"
[ -n "$SS14_HOST_USER" ]     && set -- "$@" --cvar "console.login_host_user=$SS14_HOST_USER"

# Domain-derived launcher routing (HTTPS status via proxy, UDP gameplay direct).
# SS14_PORT is the EXTERNAL host port mapped to this container (see docker-compose.yml);
# the advertised connect address must use it, not the internal 1212.
if [ -n "$SS14_DOMAIN" ]; then
  set -- "$@" --cvar "hub.server_url=ss14s://$SS14_DOMAIN"
  set -- "$@" --cvar "status.connectaddress=udp://$SS14_DOMAIN:${SS14_PORT:-1212}"
fi

# Optional PostgreSQL backend. Disabled by default; the image ships SQLite at
# /data/preferences.db. To enable, set SS14_DB_ENGINE=postgres plus the values below
# and uncomment this block.
#
# NOTE: database.pg_password is flagged CONFIDENTIAL. Passing it with --cvar puts it
# in the container's /proc/1/cmdline. Prefer the env-only route instead:
#   ROBUST_CVAR_database__pg_password=<secret>
#
# if [ "$SS14_DB_ENGINE" = "postgres" ]; then
#   set -- "$@" --cvar "database.engine=postgres"
#   set -- "$@" --cvar "database.pg_host=$SS14_DB_HOST"
#   set -- "$@" --cvar "database.pg_port=${SS14_DB_PORT:-5432}"
#   set -- "$@" --cvar "database.pg_database=$SS14_DB_NAME"
#   set -- "$@" --cvar "database.pg_username=$SS14_DB_USER"
# fi

echo "Starting Robust.Server with: $*"
exec ./Robust.Server "$@"
