FROM ubuntu:16.04

MAINTAINER Christoph Hahn <chrisi.hahni@gmail.com>

#########################
# Software: trimmomatic
# Software Version: 0.38
# Software Websit: http://www.usadellab.org/cms/?page=trimmomatic
# Description: A flexible read trimming tool for Illumina NGS data
#########################

ENV SW_NAME=Trimmomatic
ENV VERSION=0.38
ENV DEST=/usr/src/$SW_NAME
ENV ADAPTERPATH=$DEST/$VERSION/$SW_NAME-$VERSION/adapters

ADD docker_helper /usr/bin
RUN apt-get -y update --fix-missing && \
	apt-get install -y build-essential zip wget default-jre 
WORKDIR $DEST/$VERSION
RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip -O $SW_NAME-$VERSION.zip && \
	unzip $SW_NAME-$VERSION.zip && \
	echo "alias trimmomatic='java -jar $DEST/$VERSION/$SW_NAME-$VERSION/trimmomatic-0.38.jar'" >> ~/.bash_aliases && \
        echo "source ~/.bash_aliases" >> ~/.bashrc && \
	chmod +x /usr/bin/docker_helper

ENTRYPOINT ["/usr/bin/docker_helper"]


