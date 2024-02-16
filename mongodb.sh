#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

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

cp mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copied mongo.repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Updating configuration"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting mongodb"
