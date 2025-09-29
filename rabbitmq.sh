#!/bin/bash
source ./common.sh
app_name=rabbitmq
root_check

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$FILE_LOG
VALIDATE $? "Adding RabbitMQ repo"
dnf install rabbitmq-server -y &>>$FILE_LOG
VALIDATE $? "Installing RabbitMQ Server"

systemd_restart

rabbitmqctl add_user roboshop roboshop123 &>>$FILE_LOG
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$FILE_LOG
VALIDATE $? "Setting up permissions"

script_running_time