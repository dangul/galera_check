#!/bin/sh

# Password
PASSWORD=''

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' 

ClusterStatus="/usr/lib64/nagios/plugins/pmp-check-mysql-status -x wsrep_cluster_status -C == -T str -c non-Primary -p $PASSWORD"
NodeStatus="/usr/lib64/nagios/plugins/pmp-check-mysql-status -x wsrep_local_state_comment -C != -T str -w Synced -p $PASSWORD"
ClusterSize="/usr/lib64/nagios/plugins/pmp-check-mysql-status -x wsrep_cluster_size -C <= -c 1 -p $PASSWORD"
FlowControl="/usr/lib64/nagios/plugins/pmp-check-mysql-status -x wsrep_flow_control_paused -w 0.1 -c 0.9 -p $PASSWORD"

function TestStatus (){

   if [ $? -eq 0 ]; then
       printf "${GREEN}"
   else
       printf "${RED}"
   fi
}

### Main ###
printf "${NC}\nGalera Cluster Status:\n"
printf " * Cluster Status:\t"
$ClusterStatus > /dev/null 2>&1
TestStatus; $ClusterStatus

printf "${NC} * Local node state:\t"
$NodeStatus > /dev/null 2>&1
TestStatus; $NodeStatus

printf "${NC} * Cluster Size:\t"
$ClusterSize > /dev/null 2>&1
TestStatus; $ClusterSize

printf "${NC} * Flow Control:\t"
$FlowControl > /dev/null 2>&1
TestStatus; $FlowControl

printf "${NC}\n"
