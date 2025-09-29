#!/bin/bash
source ./common.sh
root_check
app_name=redis

dnf module disable redis -y &>>$FILE_LOG
VALIDATE $? "Disable Redis"

dnf module enable redis:7 -y &>>$FILE_LOG
VALIDATE $? "Enable Redis"

dnf install redis -y  &>>$FILE_LOG
VALIDATE $? "Enable Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$FILE_LOG  
VALIDATE $? "Allowing remote connections and protected-mode no"

systemd_restart
script_running_time