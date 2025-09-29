#?/bin/bash
source ./common.sh
app_name=nginx
root_check

cp SCRIPT_DIRECTORY/nginx.conf /etc/nginx/nginx.conf &>> $FILE_LOG

dnf module disable nginx -y &>> $FILE_LOG
VALIDATE $? "Disable NGINX"

dnf module enable nginx:1.24 -y &>> $FILE_LOG
VALIDATE $? "Enable NGINX version 1.24"

dnf install nginx -y &>> $FILE_LOG
VALIDATE $? "Installing NGINX"

systemctl

rm -rf /usr/share/nginx/html/*  &>> $FILE_LOG
VALIDATE $? " Remove NGINX html file"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $FILE_LOG
VALIDATE $? "Downloading the frontend zip file"

cd /usr/share/nginx/html &>> $FILE_LOG
VALIDATE $? "change directory"

unzip /tmp/frontend.zip &>> $FILE_LOG
VALIDATE $? "Unzip frontend.zip"


system_restart
script_running_time