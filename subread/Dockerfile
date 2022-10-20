# base image: Ubuntu
FROM ubuntu:22.04
RUN apt-get update --fix-missing \
&& apt-get install -y wget gcc make libbz2-dev zlib1g zlib1g-dev liblzma5 liblzma-dev libncurses5 libncurses5-dev bzip2 \
&& cd /usr/local/ \
&& wget -O subread-2.0.3-Linux-x86_64.tar.gz https://sourceforge.net/projects/subread/files/subread-2.0.3/subread-2.0.3-Linux-x86_64.tar.gz/download \
&& tar -zxvf subread-2.0.3-Linux-x86_64.tar.gz \
&& rm -rf subread-2.0.3-Linux-x86_64.tar.gz \
&& apt-get remove -y wget gcc make libbz2-dev zlib1g-dev liblzma-dev libncurses-dev bzip2 \
&& apt-get autoremove -y \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
ENTRYPOINT ["/usr/local/bin/featureCounts"]
