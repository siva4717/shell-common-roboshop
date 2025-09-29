#!/bin/bash
source ./common.sh
root_check

cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$FILE_LOG
VALIDATE $? "Adding RabbitMQ repo"
dnf install rabbitmq-server -y &>>$FILE_LOG
VALIDATE $? "Installing RabbitMQ Server"
systemctl enable rabbitmq-server &>>$FILE_LOG
VALIDATE $? "Enabling RabbitMQ Server"
systemctl start rabbitmq-server &>>$FILE_LOG
VALIDATE $? "Starting RabbitMQ"
rabbitmqctl add_user roboshop roboshop123 &>>$FILE_LOG
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$FILE_LOG
VALIDATE $? "Setting up permissions"

script_running_time