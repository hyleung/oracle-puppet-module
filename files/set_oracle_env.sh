#!/bin/bash
if [ -f /etc/oratab ] 
    then
        export ORACLE_HOME=$(cat /etc/oratab | grep  -o '[/.a-z0-9]*')
        PATH=$PATH:$ORACLE_HOME/bin
fi
