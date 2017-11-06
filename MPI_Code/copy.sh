#!/bin/bash

#checks if if a username is in the system
function userValidation {
        #if the user is valid
        if [ -z "$1" ]; then
                username=$(whoami)

        #if they did pass in a username
        else
                #making sure the user name is valid
                #if the user name is valid
                getent passwd $1 > /dev/null 2>&1
                if [ $? -eq 0 ]; then
                        #the user name is what's passed in
                        username=$1

                #else the username doesn't exist. fails
                else
                        echo "**FAILED! - $1 is Not a valid user**"
                        exit 1
                fi
        fi
}
#if the -help opthin was entered
if [ "$1" == "-help" ] || [ "$1" == "-h" ]; then
        echo -e "\nUsage: copy [arg1] [optional arg2] [optional arg3] [optional arg4]"
        echo -e "\t[arg1] = [localPath]"
        echo -e "\t[optional arg2] = [remotePath] OR [OtherUser] OR [-r]"
        echo -e "\t[optional arg3] = [OtherUser]"
        echo -e "\t[optional arg4] = [-r]"
        echo -e "default usage: copy [localpath]\n"
        exit 1
fi

#case based on the number of arguments
case "$#" in
1) #Just the path passed in
   localpath=`pwd`/"$1"
   remotepath=`pwd`/"$1"
   username=$(whoami)
   option=""
   ;;

2) # 3 cases => {2 different paths} OR {path and username} OR {path -r}
   localpath=`pwd`/"$1"

   #checking if argument 2 is a path or not
   if [ "$2" == "-r" ]; then
        remotepath=$2
        username=$(whoami)
        option="-r"
   elif [[ -d "$2" ]]; then
        remotepath=$2
        username=$(whoami)
        option=""
   else
        remotepath=`pwd`/"$1"
        userValidation $2
        option=""
   fi
   ;;

3) #2 options => {path1 path2 username} OR {path1 path2 -r}
   localpath=`pwd`/"$1"
   remotepath=$2

   if [ "$3" == "-r" ]; then
        username=$(whoami)
        option="-r"
   else
        userValidation $3
        option=""
   fi
   ;;

4) #one option
   localpath = `pwd`/"$1"
   remotepath = $2
   userValidation $3
   option = "-r"
   ;;

*) # no arguments were included. or too many.
   echo "*ERROR*"
   exit 1
   ;;
esac

#copying to the other nodes
scp $option $localpath ${username}@ub01:$remotepath
scp $option $localpath ${username}@ub02:$remotepath
scp $option $localpath ${username}@ub03:$remotepath
scp $option $localpath ${username}@ub04:$remotepath
scp $option $localpath ${username}@ub05:$remotepath
scp $option $localpath ${username}@ub06:$remotepath
scp $option $localpath ${username}@ub07:$remotepath

