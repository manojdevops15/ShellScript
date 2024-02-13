#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]

then
    echo "ERROR:: Please run this command run this command in root access"
    exit 1
else
    echo "Succesfully created mysql"
fi

yum install mysql -y