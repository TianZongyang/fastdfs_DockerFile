FROM centos:7

LABEL tzy "517614486@qq.com"

ENV FASTDFS_PATH=/opt/fdfs \
    FASTDFS_BASE_PATH=/var/fdfs \
    PORT= \
    GROUP_NAME= \
    TRACKER_SERVER= \
	FASTDFS_MODE=tracker \
	WEB_PORT=

#获取需要的依赖
RUN yum install -y git gcc gcc-c++ make wget net-tools vim pcre pcre-devel zlib zlib-devel openssl openssl-devel

#创建工作文件夹
RUN mkdir -p ${FASTDFS_PATH}/libfastcommon \
 && mkdir -p ${FASTDFS_PATH}/fastdfs \
 && mkdir -p ${FASTDFS_PATH}/nginx \
 && mkdir ${FASTDFS_BASE_PATH}

#编译libfastcommon
WORKDIR ${FASTDFS_PATH}/libfastcommon
RUN git clone https://gitee.com/tzy2333/libfastcommon.git ${FASTDFS_PATH}/libfastcommon \
 && chmod 777 make.sh && ./make.sh \
 && ./make.sh install

#编译fastdfs
WORKDIR ${FASTDFS_PATH}/fastdfs
RUN git clone https://gitee.com/tzy2333/fastdfs.git ${FASTDFS_PATH}/fastdfs \
 && chmod 777 make.sh && ./make.sh \
 && ./make.sh install
 
#编译nginx
WORKDIR ${FASTDFS_PATH}/nginx
RUN wget -c https://nginx.org/download/nginx-1.12.1.tar.gz && tar -zxvf nginx-1.12.1.tar.gz
WORKDIR ${FASTDFS_PATH}/nginx/nginx-1.12.1
RUN ./configure && make && make install

VOLUME ["$FASTDFS_BASE_PATH", "/etc/fdfs"]   
COPY conf/*.conf /etc/fdfs/
COPY conf/nginx.template /usr/local/nginx/conf/nginx.conf
COPY start.sh /usr/bin/
RUN chmod 777 /usr/bin/start.sh
ENTRYPOINT ["/usr/bin/start.sh"]
