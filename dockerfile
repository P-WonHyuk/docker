############################################################
# :: 도커파일 이미지 생성
# #docker build -t {iname}:{version} .
# :: 도커파일로 만든 이미지로 컨테이너 생성
# #docker run --privileged --name {cname} -p {host-port}:{container-port} -itd -e container=docker -v /sys/fs/cgroup:/sys/fs/cgroup {iname}:{version} /usr/sbin/init
############################################################

# tomcat 웹서버 설치 자동화

# 운영체제
FROM centos:7

# 업데이트 및 기본프로그램 설치
RUN yum update -y
RUN yum install -y net-tools
RUN yum install -y firewalld
RUN yum install -y wget
RUN yum install -y lrzsz

# JDK 1.8 설치
RUN yum install -y java-1.8.0-openjdk-devel.x86_64
RUN java -version

# Tomcat 9 설치
RUN wget https://mirror.navercorp.com/apache/tomcat/tomcat-9/v9.0.46/bin/apache-tomcat-9.0.46.tar.gz
RUN tar -zxvf apache-tomcat-9.0.46.tar.gz
RUN mv apache-tomcat-9.0.46 /usr/local/lib

# Tomcat 9 포트 오픈
# RUN firewall-cmd --zone=public --add-port=8080/tcp

# Tomcat 9 심볼릭 설정
RUN ln -s /usr/local/lib/apache-tomcat-9.0.46 /tomcat

# Tomcat 9 systemctl 등록
RUN wget https://raw.githubusercontent.com/P-WonHyuk/docker/main/tomcat.service
RUN mv tomcat.service /usr/lib/systemd/system
RUN systemctl enable /usr/lib/systemd/system/tomcat.service

# failed to get D-Bus connection : Operration not permitted
VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
