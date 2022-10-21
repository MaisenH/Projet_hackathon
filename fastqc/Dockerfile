# base image: Ubuntu
FROM ubuntu:22.04
RUN apt-get update --fix-missing 
RUN apt-get install -y wget unzip perl openjdk-8-jdk
RUN cd /usr/local/
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
RUN unzip fastqc_v0.11.9.zip 
RUN cp FastQC/fastqc /usr/local/bin/ 
RUN chmod +x /usr/local/bin/fastqc 
RUN rm -rf fastqc_v0.11.9.zip 
RUN apt-get remove -y wget unzip perl 

ENTRYPOINT ["/usr/local/bin/fastqc"]