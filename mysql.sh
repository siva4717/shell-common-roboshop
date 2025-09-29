#?/bin/bash
source ./common.sh
root_check
app_name=mysql


dnf install mysql-server -y &>>$FILE_LOG
VALIDATE $? "install mysqld" 

systemctl

mysql_secure_installation --set-root-pass RoboShop@1  &>>$FILE_LOG
VALIDATE $? "mysql_secure_installation"


script_running_time