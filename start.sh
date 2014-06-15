#!/bin/sh
/opt/elasticsearch/bin/elasticsearch -d 
/etc/init.d/nginx start
/etc/init.d/td-agent start
tail -n 10000 -f /var/log/td-agent/td-agent.log
