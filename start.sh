#!/bin/bash
#set -e
if [ -n "$PORT" ] ; then  
	sed -i "s|^port=.*$|port=${PORT}|g" /etc/fdfs/"$FASTDFS_MODE".conf
fi

if [ -n "$WEB_PORT" ] ; then  
	sed -i "s|^http\.server_port=.*$|http\.server_port=${WEB_PORT}|g" /etc/fdfs/"$FASTDFS_MODE".conf
	sed -i "s|listen       80|listen       ${WEB_PORT}|g" /usr/local/nginx/conf/nginx.conf
fi

if [ -n "$GROUP_NAME" ] ; then  
	sed -i "s|^group_name=.*$|group_name=${GROUP_NAME}|g" /etc/fdfs/storage.conf
	sed -i "s|group1|${GROUP_NAME}|g" /usr/local/nginx/conf/nginx.conf
fi

sed -i "s|#fastdfsPath#|${FASTDFS_BASE_PATH}|g" /usr/local/nginx/conf/nginx.conf

if [ -n "$TRACKER_SERVER" ] ; then  
	sed -i "s|^tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/storage.conf
	sed -i "s|^tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/client.conf
fi

FASTDFS_LOG_FILE="${FASTDFS_BASE_PATH}/logs/${FASTDFS_MODE}d.log"
PID_NUMBER="${FASTDFS_BASE_PATH}/data/fdfs_${FASTDFS_MODE}d.pid"

echo "尝试启动 $FASTDFS_MODE 节点..."
if [ -f "$FASTDFS_LOG_FILE" ]; then 
	rm "$FASTDFS_LOG_FILE"
fi
# start the fastdfs node.	
fdfs_${FASTDFS_MODE}d /etc/fdfs/${FASTDFS_MODE}.conf start

if [ "$FASTDFS_MODE" == "storage"  ] ; then  
	/usr/local/nginx/sbin/nginx
fi

# wait for pid file(important!),the max start time is 5 seconds,if the pid number does not appear in 5 seconds,start failed.
TIMES=5
while [ ! -f "$PID_NUMBER" -a $TIMES -gt 0 ]
do
    sleep 1s
	TIMES=`expr $TIMES - 1`
done
tail -f "$FASTDFS_LOG_FILE"
