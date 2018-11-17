# fastdfs_DockerFile
包含fastdfs和nginx的docker容器的dockerfile

DockerHub地址为:https://hub.docker.com/r/tzy111/fastdfs/

Dockerfile中编译libfastcommon和编译fastdfs因为网络问题使用了国内码云的git地址,如果想要最新的可以改为github相关项目的最新地址
nginx使用了1.12.1版本,下载速度过慢可以修改为国内源地址

Tracker使用方法：
docker run -d --net=host -e PORT=16666 -e FASTDFS_MODE=tracker -e WEB_PORT=81 -v /home/fdfs/tracker:/var/fdfs --name tracker -it tzy111/fastdfs:latest
Storage使用方法：
docker run -d --net=host -e PORT=16667 -e FASTDFS_MODE=storage -e TRACKER_SERVER=<IP_ADDR>:16666 -e GROUP_NAME=group1 -e WEB_PORT=82 -v /home/fdfs/storage0:/var/fdfs --name storage0 -it tzy111/fastdfs:latest
参数解释：
PORT参数代表fdfs的端口号
FASTDFS_MODE表示是启动tracker还是storage模式，启动storage时会一起启动nginx服务器
WEB_PORT对应tracker.conf和storage.conf中的http.server_port参数，同时在storage模式下也对应nginx的启动端口
TRACKER_SERVER在storage必须要，代表tracker的地址
FASTDFS_BASE_PATH代表docker容器内fdfs的文件保存位置，默认为/var/fdfs ，记得用-v和宿主机的路径进行映射