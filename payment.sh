#?/bin/bash
source ./common.sh
root_check
app_name=payment

dnf install python3 gcc python3-devel -y &>>$FILE_LOG
VALIDATE $? "Installing python3"

app_setup

pip3 install -r requirements.txt &>>$FILE_LOG
VALIDATE $? "mvn clean package" 

systemd_restart
system_restart
script_running_time
