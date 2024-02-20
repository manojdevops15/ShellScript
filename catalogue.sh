#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGODB=172.31.7.145

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE () {

    if [ $? -ne 0 ]
    then
        echo -e "$2 .......... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ...........$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR :: this script was run in the only root user so please go to root user $N"
    exit 1
else
    echo  -e "Your in the root user"
fi

dnf module disable nodejs -y

VALIDATE $? "disable nodejs previous version"

dnf module enable nodejs:18 -y

VALIDATE $? "enable nodejs updated version"

dnf install nodejs -y

VALIDATE $? "instaling nodejs"

id roboshop

if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user created"
else
    echo "roboshop user already created so creation was skipping"
fi

mkdir -p /app

VALIDATE $? "created the app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "download roboshop application"

cd /app 

VALIDATE $? "go to the app directory"

unzip -o /tmp/catalogue.zip

VALIDATE $? "unzip the roboshop application"

cd /app

npm install 

VALIDATE $? "npm installed succesfully"

cp /home/Devops/daws-76/repos/ShellScript/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "coping catalogue file"

systemctl daemon-reload

VALIDATE $? "daemon reloaded succesfully"

systemctl enable catalogue

VALIDATE $? "enablled catalogue"

systemctl start catalogue

VALIDATE $? "started catalogue"

cp /home/Devops/daws-76/repos/ShellScript/catalogue.service /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copied mongodb repo"

dnf install mongodb-org-shell -y

VALIDATE $? "installed mongodb-org-shell"

mongo --host $MONGODB </app/schema/catalogue.js

VALIDATE $? "change ip address"


