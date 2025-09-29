#?/bin/bash
source ./common.sh
app_name=shipping
root_check

dnf install maven -y &>>$FILE_LOG
VALIDATE $? "Installing maven"

system_user
app_setup

mvn clean package &>>$FILE_LOG
VALIDATE $? "mvn clean package" 

mv target/shipping-1.0.jar shipping.jar  
VALIDATE $? "move the shipping.jar file"

systemctl

dnf install mysql -y  &>>$FILE_LOG

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi

system_restart
script_running_time