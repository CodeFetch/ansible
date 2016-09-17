# ffh supernodes

## roles

### dependency tree

    ─┬─ batman ─── fastd_mesh ─┬─ fastd_mesh_remotes_backbone
     |                         └─ fastd_mesh_remotes_peers_git
     ├─ cli_tools
     ├─ networkd ─── batman
     ├─ git_autoupdate ─── fastd_mesh_remotes_peers_git
     └─ ssh_known_hosts ─── fastd_mesh_remotes_peers_git


### role descriptions

- **networkd:** replaces debian networking with systemd-networkd
    - host_vars: ```networkd_uplink.interface, networkd_uplink.networks, networkd_uplink.dns```
    - creates a configuration for the uplink interface
- **batman:** provides bat0 interface, sets ips to it
    - host vars: ```ip4_bat0, ip6_bat0```
- **fastd\_mesh:** adds fastd_mesh interface to bat0
    - host vars: ```fastd_mesh_mac, fastd_mesh_secret```
    - doesn't work without remotes role
- **fastd\_mesh\_remotes\_backbone:** provides access to other supernodes
- **fastd\_mesh\_remotes\_peers\_git:** provide access to peers repo
    - host vars: ```git_addr```
    - installs cronjob to autoupdate peers
- **cli\_tools:** install some cli tools
    - ```netcat-openbsd```
    - ```tcpdump```
- **ssh\_known\_hosts:** install systemwide known_hosts to verify remotes
- **git\_autoupdate:** autoupdate git repositorys
    - provides generic update script for use in cronjobs
        - exit status indicates whether the repo has changed
    - cronjobs should run as user: ```auto```
