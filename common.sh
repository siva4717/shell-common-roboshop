#?/bin/bash

#user id
USER_ID=$(id -u)

#colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#log directory
FILE_LOG_DIRECTORY="/var/log/shell-roboshop/"
SCRIPT_NAME=$(echo $0 | cut -d '.' -f1)
FILE_LOG=$FILE_LOG_DIRECTORY/$SCRIPT_NAME.log
script_dir=$PWD
MONGODB_HOST="mongodb.msgd.fun"
MYSQL_HOST="mysql.msgd.fun"
START_TIME=$(date +'%s')

mkdir -p $FILE_LOG_DIRECTORY 
echo -e "$G The script Started at ::: $(date)$N"

#Root check
root_check(){
    if [ $USER_ID -ne 0 ]; then 
        echo -e " $R You can use root user $N" 
        exit 1
    fi
}

#validate
VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e " $2 ... $R failure $N "
    else
        echo -e " $2 ... $G success $N "
    fi
}

##### NodeJS ####
nodejs_setup(){
    dnf module disable nodejs -y &>>$FILE_LOG
    VALIDATE $? "Disabling NodeJS"
    dnf module enable nodejs:20 -y  &>>$FILE_LOG
    VALIDATE $? "Enabling NodeJS 20"
    dnf install nodejs -y &>>$FILE_LOG
    VALIDATE $? "Installing NodeJS"
    npm install &>>$FILE_LOG
    VALIDATE $? "Install dependencies"
}

#system-user
system_user(){
    id roboshop &>>$FILE_LOG
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$FILE_LOG
        VALIDATE $? "Creating system user"
    else
        echo -e "User already exist ... $Y SKIPPING $N"
    fi
}

#app_setup
app_setup(){
    mkdir -p /app
    VALIDATE $? "Creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$FILE_LOG
    VALIDATE $? "Downloading $app_name application"

    cd /app 
    VALIDATE $? "Changing to app directory"

    rm -rf /app/*
    VALIDATE $? "Removing existing code"

    unzip /tmp/$app_name.zip &>>$FILE_LOG
    VALIDATE $? "unzip $app_name"

    cp $script_dir/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copy systemctl service"
}

#systemctl service
systemd_restart(){
    systemctl daemon-reload
    systemctl enable $app_name &>>$FILE_LOG
    VALIDATE $? "Enable $app_name"
}

#system restart
system_restart(){
    systemctl restart $app_name &>>$FILE_LOG
    VALIDATE $? "Systemctl restart" 
}

#script running time
script_running_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "Script executed in: $Y $TOTAL_TIME Seconds $N" 
}