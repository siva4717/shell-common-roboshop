#?/bin/bash
source ./common.sh
app_name=mongod

root_check

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$FILE_LOG
VALIDATE $? "Adding mongo repo"

dnf install mongodb-org -y &>>$FILE_LOG
VALIDATE $? "mongodb" 

systemctl enable mongod &>>$FILE_LOG
VALIDATE $? "Systemctl enable" 

systemctl start mongod &>>$FILE_LOG
VALIDATE $? "Systemctl start" 

sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$FILE_LOG    
VALIDATE $? "allowing remote connections mongodb" 

systemd_restart
script_running_time
