FROM timbru31/ruby-node:2.7 as builder
# sudo apt-get update
# sudo apt-get upgrade
# sudo apt-get install python-software-properties
# sudo apt-get install software-properties-common
# sudo add-apt-repository ppa:webupd8team/java
# sudo apt-get update

RUN apt-get update \
    && apt-get upgrade \
    && apt-get install python-software-properties \
    && apt-get install software-properties-common \
    && add-apt-repository ppa:webupd8team/java \
    && apt-get update
