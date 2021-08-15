#!/bin/bash

#===============================================================================
#title           : SSH_Deploy.sh
#description     : It'll perform all deployment activities on remote server
#author          : RamanaReddy V
#date            : 08-07-2021
#version         : 0.1    
#usage           : bash SSH_Deploy.sh (i.e. GIT BASH)
#===============================================================================

BuildFIlesPath=$ARTIFACTS_LOCATION # $APPDATA  # 

win_to_Shell_path_convert () { f="${1/C://c}"; echo "${f//\\//}"; } # only for C drive 
outputPath=$( win_to_Shell_path_convert "$BuildFIlesPath" )
echo ${outputPath}

echo "================== Started  SSH AGENT within GIT BASH  ======================"
eval `ssh-agent -s`
echo "================== END  SSH AGENT within GIT BASH  ======================"

echo "================== Started  SSH AGENT Private Key  ======================"
ssh-add $HOME/.ssh/$AWS_PRIVATE_KEY_NAME
echo "================== END  SSH AGENT Private Key  ======================"

echo "================== Started  App pool  stop  ======================"
SSH $AWS_SERVER_USER@$AWS_SERVER_HOSTNAME "Stop-WebAppPool -Name DefaultAppPool"
if [ $? != 0 ]
then
    echo $?
    echo " ERROR :: DefaultAppPool Stop Error "
    exit 1
fi

echo "================== END  App pool  stop  ======================"

echo "================== Started  deployment build files to remote server  ======================"
scp -r ${outputPath}/Demo/* $AWS_SERVER_USER@$AWS_SERVER_HOSTNAME:C:/core
if [ $? != 0 ]
then
    echo $?
    echo " ERROR :: deployment build files"
    exit 1
fi
echo "================== END  deployment build files to remote server  ======================"

echo "================== Started  App pool  start  ======================"
SSH $AWS_SERVER_USER@$AWS_SERVER_HOSTNAME "Start-WebAppPool -Name DefaultAppPool"
if [ $? != 0 ]
then
    echo $?
    echo " ERROR :: DefaultAppPool Stop Error "
    exit 1
fi

echo "================== END  App pool  start  ======================"

echo "================== Started  Removing Private key in CIRCLECI VM  ======================"
cd $HOME
ssh-add -D
echo "================== End  Removing Private key in CIRCLECI VM  ======================"