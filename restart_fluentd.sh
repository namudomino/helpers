#!/bin/bash

########################################
## Rolling restart Fluentd Daemonset ###
########################################

set -e  

restart_fluentd() {
  printf "Restarting Fluent DaemonSet\n"
  ns=$1
  restart=$(kubectl rollout restart ds/fluentd -n $ns)
  if [ $? -eq 0 ];then
    printf "checking the status of the fluentd restart in 30 seconds \n"
    sleep 30
    check_status $ns
  fi
}

check_status() {
  ns=$1
  status=$(kubectl rollout status ds/fluentd -n $ns)
  now="$(date)"
  if [[ $status ==  *"successfully rolled out"* ]];then
    printf "Fluentd daemonset rolled out successfully $now"
  else 
    printf "Fluentd daemonset rolling restart failed at $now" 
  fi
}

 
ns=$(kubectl get ns -l domino-platform=true -o=jsonpath="{.items[0].metadata.name}")
restart_fluentd $ns
