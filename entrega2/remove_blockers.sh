#!/bin/bash

#Inputs
APP_NAME=$1
BLOCKER_FILE=$2

export BLOCK_APP=$APP_NAME
envsubst < $BLOCKER_FILE | kubectl delete -f -