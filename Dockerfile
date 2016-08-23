# LEMP stack as a docker container
FROM ubuntu:latest
#ENV http_proxy http://proxy.example.com:8080
#ENV https_proxy https://proxy.example.com:8080
 
RUN apt-get update
RUN apt-get -y upgrade
# seed database password
COPY mysqlpwdseed /root/mysqlpwdseed
RUN debconf-set-selections /root/mysqlpwdseed
 
RUN apt-get -y install mysql-server
 
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
 
RUN /usr/sbin/mysqld & \
    sleep 10s &&\
    echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -u root --password=secret &&\
    echo "create database test" | mysql -u root --password=secret
 
# persistence: http://txt.fliglio.com/2013/11/creating-a-mysql-docker-container/ 
 
EXPOSE 3306
 
CMD ["/usr/bin/mysqld_safe"]