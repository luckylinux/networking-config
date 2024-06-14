# networking-config
networking-config

# Introduction
Note that this is only **one** possible approach.

You can probably achieve the same through Ansible, Salt/Saltstack or any other Automation/Configuration Management System.

The approach used here is something that allows both Centralized Configuration Management and Manual/Local Configuration and Overrides, in case e.g. where your Configuration Management System is not working reliably.

You can also choose different Approaches (e.g. 1 Systemd Service per each Route or Address) etc.

# Setup
Clone Repository:
```
git clone https://github.com/luckylinux/podman-network-setup.git
```

Run Setup:
```
./setup.sh
```
# SNID External Server
SNID Routes to External Servers are configured in `/etc/snid/routes.external.d/<server>.sh`.

Look at the Examples in `etc/networking-snid/routes.external.d/example1.sh` and `etc/networking-snid/routes.external.d/example2.sh` for more Information.

Enable Systemd Service:
```
systemctl enable --now snid-external-routes.service
```

Check that no Errors Occurred:
```
systemctl status snid-external-routes.service
```

# Local SNID Server
SNID Server and Routes to Local Servers (running on the same Host as Podman Host) are configured in:
- Routes: `/etc/networking-snid/routes.local.d/<server>.sh`
- Server: `/etc/networking-snid/servers.local.d/<server>.sh`

Look at the Examples in `etc/networking-snid/routes.local.d/example.sh` and `etc/networking-snid/servers.local.d/example.sh` for more Information.

## Enable Routes Services
Enable Systemd Services:
```
systemctl enable --now snid-local-routes.service
```

Check that no Errors Occurred:
```
systemctl status snid-local-routes.service
```

## Enable Servers Services
Enable Systemd Services:
```
systemctl enable --now snid-server.service
```

Check that no Errors Occurred:
```
systemctl status snid-server.service
```


# Container Networking
For every User (and multiple times per User, if desired) configure a Network that the User can "Manage" on its own and configure the appropriate Local Route for that.

See Example in `etc/containers-networking/addresses.local.d/podman.sh`

Enable Systemd Service:
```
systemctl enable --now container-routes.service
```

Check that no Errors Occurred:
```
systemctl status container-routes.service
```

