set positional-arguments := true

[doc("Manage the pihole configuration")]
[group("apps")]
mod pihole "pihole.just"

[group("help")]
[doc("Show recipes")]
@help:
    just --list --list-prefix "  "

