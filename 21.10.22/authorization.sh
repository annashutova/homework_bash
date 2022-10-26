#!/bin/bash
exec 2> auth_error
flag=1
while [[ $flag -eq 1 ]]
do
    echo "Enter your login: "
    read login
    flag_log=0
    while read line
    do
        if [[ $flag_log -eq 1 ]]
        then
            correct_pswd=$line
        fi
        if [[ $line == $login ]]
        then
            flag_log=1
        fi
    done < users_data
    if [[ $flag_log -eq 0 ]]
    then
        echo "Login $login does not exist! Try again."
        echo "Non-existent login: $login was typed." >&2
    else
        try=1
        while [[ $try -le 3 ]]
        do
            echo "Enter your password: "
            read -t 10 -s pswd
            echo "$pswd" | md5sum > user_pswd
            pass=0
            while read pswd
            do
                pass=$pswd
            done < user_pswd
            if [[ $pass == $correct_pswd ]]
            then
                echo "You have logged in!"
                flag=0
                break
            else
                echo "Wrong password! $((3-$try)) attempts left."
                echo "Wrong password for login: $login. $((3-$try)) attempts left." >&2
                try=$(($try+1))
            fi
        done
        if [[ $try -eq 4 ]]
        then
            echo "Unsuccessfull authorization!"
            echo "Unsuccessfull authorization for login: $login" >&2
        fi
    fi
done
