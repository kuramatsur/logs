FROM centos
MAINTAINER k2

#yum
ADD td.repo /etc/yum.repos.d/td.repo
RUN rpm --import http://packages.treasure-data.com/redhat/RPM-GPG-KEY-td-agent
RUN yum update -y

RUN yum install -y which

#wget
RUN yum install -y wget

#tar
RUN yum install -y tar

#git
RUN yum install -y git

#fluend
RUN yum install -y td-agent --enablerepo=treasuredata

#
RUN (yum install -y gcc && yum install -y libcurl-devel)
RUN /usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-elasticsearch


#sshd
RUN yum install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd



#JAVA
RUN yum -y install java-1.7.0-openjdk

#elastic search
RUN (cd /tmp && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.tar.gz -O pkg.tar.gz && tar zxf pkg.tar.gz && mv elasticsearch-* /opt/elasticsearch)
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/jre


EXPOSE 9200
EXPOSE 9300
VOLUME /opt/elasticsearch/data


#nginx
RUN (rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm && yum install -y nginx)
                                                                                                             

#kibana
#RUN (cd /opt && git clone --branch=kibana-ruby https://github.com/rashidkpc/Kibana.git)
RUN  (cd /tmp && wget https://download.elasticsearch.org/kibana/kibana/kibana-3.0.0milestone5.tar.gz && tar zxf kibana-3.0.0milestone5.tar.gz && mv kibana-3.0.0milestone5 /opt/kibana)

RUN ln -s /opt/kibana /usr/share/nginx/html/kibana


#clean up
RUN rm -rf /tmp/*

VOLUME /data

ADD start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

CMD /usr/local/bin/start.sh
