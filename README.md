# ffh supernodes

## roles

### dependency tree

    ─┬─ batman ─── fastd_mesh ─┬─ fastd_mesh_remotes_backbone
     |                         └─ fastd_mesh_remotes_peers_git
     ├─ cli_tools
     └─ ssh_known_hosts ─── fastd_mesh_remotes_peers_git


### role descriptions

- **batman:** provides bat0 interface, sets ips to it
    - host vars: ```ip4_bat0, ip6_bat0```
- **fastd\_mesh:** adds fastd_mesh interface to bat0
    - host vars: ```fastd_mesh_mac, fastd_mesh_secret```
    - doesn't work without remotes role
- **fastd\_mesh\_remotes\_backbone:** provides access to other supernodes
- **fastd\_mesh\_remotes\_peers\_git:** provide access to peers repo
    - host vars: ```git_addr```
    - installs cronjob to autoupdate peers (user: auto)
- **cli\_tools:** install some cli tools
    - ```netcat-openbsd```
    - ```tcpdump```
- **ssh\_known\_hosts:** install systemwide known_hosts to verify remotes