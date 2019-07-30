#!/bin/bash

# source: https://docs.docker.com/engine/admin/multi-service_container/

# Start the first process
taskd.py &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start task daemon: $status"
  exit $status
fi

# Start the second process
manage.py eparch computenode_poll --repeat -v 3 &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start computenode poll: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container will exit with an error
# if it detects that either of the processes has exited.
# Otherwise it will loop forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep taskd |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep computenode_poll |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they will exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
done
