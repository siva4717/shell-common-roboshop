#!/bin/bash
source ./common.sh
root_check
app_name=cart

app_setup
nodejs_setup
system_user
systemd_restart
system_restart
script_running_time

