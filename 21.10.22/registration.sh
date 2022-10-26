#!/bin/bash
exec 2>reg_error
echo "Welcome to registration script!"
flag_login=1
while [ $flag_login -eq 1 ]
do
    echo "Create a login: "
    read login
    if [[ ${#login} -lt 8 ]]
    then
        echo "Login length is less than 8 characters."
        echo "Login length is less than 8 characters." >&2
    else
        if grep -w -q "$login" users_data
        then
            echo "Login is occupied. Please, try again."
            echo "Login $login is occupied." >&2
        else
            flag_login=0
            echo "Good nickname!"
            echo "$login" >> users_data
            flag_pswd=1
            while [ $flag_pswd -eq 1 ]
            do
                echo "Create a password: "
                read -s pswd
                if [[ ${#pswd} -lt 12 ]]
                then
                    echo "Password length is less than 12 characters."
                    echo "Password length is less than 12 characters." >&2
                else
                    flag_pswd=0
                    echo "Safe password!"
                    echo $pswd | md5sum >> users_data
                    echo "You have successfully logged!"
                fi
            done
        fi
    fi
done
