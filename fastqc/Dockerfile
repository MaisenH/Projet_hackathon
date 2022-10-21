# base image: Ubuntu
FROM ubuntu:22.04
RUN apt-get update --fix-missing \
&& apt-get install -y wget unzip perl \
&& cd /usr/local/ \
&& wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip\
&& cp subread-2.0.3-Linux-x86_64/bin/featureCounts /usr/local/bin/ \
&& unzip fastqc_v0.11.9.zip
&& chmod 755 /FastQC/fastqc \
&& rm -rf fastqc_v0.11.9.zip \
&& apt-get remove -y wget unzip perl \

ENTRYPOINT ["/usr/local/bin/fastqc"]