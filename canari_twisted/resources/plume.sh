#!/bin/bash

# Change these values to suit your needs
PLUME_USER=nobody
PLUME_GROUP=nobody
PLUME_PORT=80

export PYTHONPATH=/opt/tdsTransforms/collection

# *******IMPORTANT*********: Comment or remove the two lines below once you've finished editing this file
#echo "You forgot to look at this file ($0) so we've decided to punish you by exiting prematurely (how rude!)."
#exit 255

# Do not change anything below this line unless you know what you're doing.

PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin
PID_FILE=/var/run/plume.pid
WORKING_DIR=/opt/plume


case $1 in
    start)
        echo -n 'Starting plume: '
        twistd \
                --pidfile=$PID_FILE \
                --rundir=$WORKING_DIR \
                --uid=$(id -u $PLUME_USER) \
                --gid=$(grep $PLUME_GROUP /etc/group | cut -f 3 -d ':') \
                web \
                --wsgi=plume.application \
                --logfile=plume.log \
                --port=$PLUME_PORT;
        sleep 1
        if [ -f $PID_FILE ]; then
            echo 'done.';
        else
            echo 'failed.';
        fi;
        ;;
    stop)
        echo -n 'Stopping plume: '
        if [ -f $PID_FILE ]; then
            kill -9 $(cat $PID_FILE);
            rm -f $PID_FILE;
        fi;
        echo 'done.'
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    status)
        if [ -f $PID_FILE ]; then
            echo 'Plume: running...';
        else
            echo 'Plume: stopped.';
        fi;
        ;;
    *)
        echo "usage: $0 {start|stop|restart|status}" >&2
        ;;
esac;
