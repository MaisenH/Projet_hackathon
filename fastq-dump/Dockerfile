FROM ubuntu:22.04

RUN apt-get update --fix-missing 
RUN apt-get install -y wget
RUN wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar -vxzf sratoolkit.tar.gz

