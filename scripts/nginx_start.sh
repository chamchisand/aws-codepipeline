#!/bin/bash

pid=$(pgrep -fl nginx)
pid=$(echo "$pid" | grep -v "nginx_start")

if [ -n "$pid" ]; then
  service nginx reload
else
  service nginx start
fi
