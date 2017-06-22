#!/bin/sh
# common routines for readiness and liveness probes

CLI_TIMEOUT=10s
CLI_KILLTIME=30s

run_cli_cmd() {
    cmd="$1"
    timeout --foreground -k "$CLI_KILLTIME" "$CLI_TIMEOUT" cat "$cmd"
}

is_nginx() {
    run_cli_cmd "/run/nginx.pid"
}
