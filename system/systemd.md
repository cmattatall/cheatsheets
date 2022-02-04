# Making a basic systemd service


```
[Unit]
Description=A description of my service

# Using "After" states boot order but does not state dependencies. 
# E.G if your service NEEDS a network connection, it should use Requires=network-online.target rather than After
After=network-online.target

# Using "Requires" states dependencies
Requires=network-online.target

[Service]
Type=simple
ExecStart=/bin/bash my_command_to_start_my_service._It_doesnt_have_to_be_a_shell_script._it_can_be_other_commands_too
ExecStop=/bin/bash my_command_to_stop_my_service._It_doesnt_have_to_be_a_shell_script._it_can_be_other_commands_too
ExecRestart=/bin/bash my_command_to_restart_my_service._It_doesnt_have_to_be_a_shell_script._it_can_be_other_commands_too

Restart=on-failure
StandardOutput=file:/path/to/my/standard_output_logfile.log
StandardError=file:/path/to/my/standard_error_logfile.log

[Install]
WantedBy=multi-user.target

```


# A more advanced example

```
[Unit]
Description=My service
Documentation=man:bluetoothd(8)

# Only start the service if this is true
ConditionPathIsDirectory=/sys/class/bluetooth


[Service]
Type=dbus
BusName=org.bluez
ExecStart=/usr/lib/bluetooth/bluetoothd
NotifyAccess=main
#WatchdogSec=10
Restart=on-failure
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
LimitNPROC=1
ProtectHome=true
ProtectSystem=full

[Install]
WantedBy=bluetooth.target
Alias=dbus-org.bluez.service

```

