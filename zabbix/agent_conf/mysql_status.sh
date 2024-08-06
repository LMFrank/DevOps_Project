#!/bin/bash

CONNECTION1="mysqladmin -uroot -ppassword status"
CONNECTION2="mysqladmin -uroot -ppassword extended-status"
if [ $# -ne 1 ];then
        echo "arg error,there should be one arg!"
else
        case $1 in
                uptime)
                        result=`$CONNECTION1 | awk '{print $2}'`
                        ;;
                threads)
                        result=`$CONNECTION1 | awk '{print $4}'`
                        ;;
                slow_queries)
                        result=`$CONNECTION1 | awk '{print $9}'`
                        ;;
                avg_time)
                        result=`$CONNECTION1 | awk '{print $22}'`
                        ;;
                bytes_sent)
                        result=`$CONNECTION2 | grep "Bytes_sent" |awk '{print $4}'`
                        ;;
                *)
                        echo "Usage:$0(uptime|threads|slow_queries|avg_time|bytes_sent)"
        esac
        echo $result
fi


