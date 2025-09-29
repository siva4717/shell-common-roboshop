#!/bin/bash
source ./common.sh
root_check
app_name=user

app_setup
nodejs_setup
systemd_restart
system_restart
script_running_time

