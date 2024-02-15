#!/bin/bash

ID=$(id -u)

VALIDATE() {

if [ $1 -ne 0 ]
then 
    echo "$2 ..... SUCCESS"
else
    echo "$2 ....... FAILED"
}

if [ $ID -ne 0 ]
then
    echo "Error :: Your not root user"
else
    echo "Your are in root user"
fi

for package in $@
do

yum list installed $package

if [ $? -ne o ]
then
    yum install $package
    VALIDATE $? "installing $package"
else
    echo "$package already installed"
fi