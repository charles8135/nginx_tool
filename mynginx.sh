#!/bin/bash

BASE_DIR="/home/$USER/local/nginx"
NGINX_CONF_FILE=$BASE_DIR"/conf/nginx.conf"
NGINX_PID_FILE=$BASE_DIR"/logs/nginx.pid"
nginx=$BASE_DIR"/sbin/nginx"


configtest() {
  $nginx -t -c $NGINX_CONF_FILE
}

function is_running(){
  if [ ! -e $NGINX_PID_FILE ] || [ -z $NGINX_PID_FILE ]; then
    echo "nginx is not running"
    exit 1  
  fi
  return 0
}

function start(){
  configtest || return $?
  echo "mynginx start..."
  $nginx -c $NGINX_CONF_FILE -p $BASE_DIR/
  retval=$?
  [ $retval -eq 0 ] || echo "start failed"
  return $retval
}

function stop(){
  is_running
  echo "mynginx stop..."
  pid=`cat $NGINX_PID_FILE`
  kill -QUIT $pid
  retval=$?
  [ $retval -eq 0 ] || echo "stop failed"
  return $retval
}

function restart(){
  configtest || return $?
  is_running
  echo "mynignx restart..."
  pid=`cat $NGINX_PID_FILE`
  kill -HUP $pid
  retval=$?
  [ $retval -eq 0 ] || echo "restart failed"
  return $retval
}

## main()
case "$1" in
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "restart")
        restart
        ;;
    "configtest")
        configtest
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|configtest}"
esac
exit 0
