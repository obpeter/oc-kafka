FROM rhel
RUN mkdir -p /opt/kafka \
  && cd /opt/kafka \
  && ln -s /var/run/secrets/rhel7.repo /etc/yum.repos.d/rhel7.repo \
  && yum -y install java-1.8.0-openjdk-headless tar
  
RUN curl http://www.mirrorservice.org/sites/ftp.apache.org/kafka/0.10.2.0/kafka_2.11-0.10.2.0.tgz -o /opt/kafka/kafka_2.11-0.10.2.0.tgz

RUN yum clean all
RUN rm /etc/yum.repos.d/rhel7.repo

RUN cd /opt/kafka && tar xzvf kafka_2.11-0.10.2.0.tgz --strip-components=1
RUN rm /opt/kafka/kafka_2.11-0.10.2.0.tgz
RUN rm -r /opt/kafka/bin/windows
RUN curl -Lo /opt/kafka/libs/jolokia.jar http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.3.6/jolokia-jvm-1.3.6-agent.jar
 
COPY zookeeper-server-start-multiple.sh /opt/kafka/bin/
COPY zookeeper-server-start-multi-single.sh /opt/kafka/bin/

RUN chmod 777 /opt/kafka/bin/zookeeper-server-start-multi-single.sh

RUN mkdir /opt/kafka/certs
COPY server.keystore.jks opt/kafka/certs/

RUN chmod -R a=u /opt/kafka
WORKDIR /opt/kafka
VOLUME /tmp/kafka-logs /tmp/zookeeper

RUN mkdir /opt/kafka/custom

EXPOSE 2181 2888 3888 9092 9093 8778
