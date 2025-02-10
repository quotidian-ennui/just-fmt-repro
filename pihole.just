set positional-arguments := true

MODULE_SOURCE := "pihole.just"

# show recipes
@help:
    just --list --list-prefix "  " --justfile "{{ MODULE_SOURCE}}"

# update pihole adlists
update:
    #!/usr/bin/env bash
    # Thing to update lists we can compile from the web.
    #
    set -eo pipefail
    FIREBOG_URL="https://v.firebog.net/hosts/lists.php?type=tick"
    ANUDEEP_WHITELIST="https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"
    PIHOLE_ADLISTS="$(git rev-parse --show-toplevel)/resources/pihole/adlists.txt"
    PIHOLE_WHITELIST="$(git rev-parse --show-toplevel)/resources/pihole/whitelist.txt"
    function do_adlists() {
      firebog_data=$(curl -fsSL "${FIREBOG_URL}")
      existing_adlist=$(cat "${PIHOLE_ADLISTS}")
      (printf '%s\n%s\n' "$existing_adlist" "$firebog_data" | awk '!seen[$0]++') >"$PIHOLE_ADLISTS"
    }
    function do_whitelist() {
      anudeep_data=$(curl -fsSL "${ANUDEEP_WHITELIST}")
      existing_whitelist=$(cat "${PIHOLE_WHITELIST}")
      (printf '%s\n%s\n' "$existing_whitelist" "$anudeep_data" | awk '!seen[$0]++') >"$PIHOLE_WHITELIST"
    }
    do_adlists
    do_whitelist
