FROM ubuntu:14.04

RUN sudo apt-get update \
    && sudo apt-get install -y python-software-properties \
    && sudo apt-get install -y software-properties-common \
    && sudo add-apt-repository ppa:webupd8team/java \
    && sudo apt-get update \
    && sudo -E add-apt-repository ppa:openjdk-r/ppa \
    && sudo apt-get update \
    && sudo apt-get install -y openjdk-8-jdk \
#     && sudo apt-get install -y mysql-server \
    && sudo apt-get install -y wget \
    && sudo apt-get install zip unzip

RUN sudo wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.85/bin/apache-tomcat-7.0.85.tar.gz \
    && sudo mv apache-tomcat-7.0.85.tar.gz /usr/share \
    && cd /usr/share \
    && sudo tar xvf apache-tomcat-7.0.85.tar.gz \
    && sudo rm -f apache-tomcat-7.0.85.tar.gz \
    && sudo mv apache-tomcat-7.0.85 tomcat7 && cd ~


# SSL
RUN sudo keytool -genkey -keyalg RSA -alias tomcat -keystore /usr/share/tomcat.keystore

COPY server.xml /usr/share/tomcat7/conf/server.xml

# JDBC Connector
RUN cd /usr/share/tomcat7/lib \
    && sudo wget https://repo1.maven.org/maven2/org/drizzle/jdbc/drizzle-jdbc/1.3/drizzle-jdbc-1.3.jar

# MYSQL connector

COPY mysql-connector-java-5.1.49/mysql-connector-java-5.1.49-bin.jar /usr/share/tomcat7/lib/
COPY mysql-connector-java-5.1.49/mysql-connector-java-5.1.49.jar /usr/share/tomcat7/lib/

# RUN sudo wget https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.49.tar.gz \
#     && tar -xvf mysql-connector-java-5.1.49.tar.gz \
#     && rm -r mysql-connector-java-5.1.49.tar.gz \
#     && sudo mv mysql-connector-java-5.1.49/mysql-connector-java-5.1.49-bin.jar /usr/share/tomcat7/lib/ \
#     && sudo mv mysql-connector-java-5.1.49/mysql-connector-java-5.1.49.jar /usr/share/tomcat7/lib/ \
#     && rm -r mysql-connector-java-5.1.49

COPY tomcat /etc/init.d/tomcat7

RUN sudo chmod 755 /etc/init.d/tomcat7 \
    && sudo ln -s /etc/init.d/tomcat7/etc/rc1.d/K99tomcat \
    && sudo ln -s /etc/init.d/tomcat7/etc/rc2.d/S99tomcat


RUN cd /usr/src \
    && sudo wget http://jaist.dl.sourceforge.net/project/mifos/Mifos%20X/mifosplatform-18.03.01.RELEASE.zip \
    && sudo unzip mifosplatform-18.03.01.RELEASE.zip \
    && cd fineractplatform-18.03.01.RELEASE


RUN cd /usr/src/fineractplatform-18.03.01.RELEASE \
    && sudo cp fineract-provider.war /usr/share/tomcat7/webapps/ \
    && sudo cp -r apps/community-app/ /usr/share/tomcat7/webapps/ \
    && sudo cp -r api-docs/ /usr/share/tomcat7/webapps/ \
    && cd /usr/share/tomcat7/webapps \
    && sudo mv ROOT OLDROOT \
    && sudo mv community-app ROOT

# Reports
RUN sudo su \
    && cd /root \
    && mkdir .mifosx \
    && cp -r /usr/src/fineractplatform-18.03.01.RELEASE/pentahoReports/root/.mifosx

# RUN sudo /etc/init.d/tomcat7 start