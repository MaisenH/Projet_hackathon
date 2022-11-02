# base image: Ubuntu
FROM ubuntu:22.04
RUN apt-get update --fix-missing \
&& apt-get install -y wget gcc make libbz2-dev zlib1g zlib1g-dev liblzma5 liblzma-dev libncurses5 libncurses5-dev bzip2 \
&& cd /usr/local/ \
&& wget -O sratoolkit.3.0.0-ubuntu64.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-ubuntu64.tar.gz \
&& tar -zxvf sratoolkit.3.0.0-ubuntu64.tar.gz \
&& rm -rf sratoolkit.3.0.0-ubuntu64.tar.gz \
&& wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz \
&& tar -zxvf sratoolkit.current-ubuntu64.tar.gz \
&& rm -rf sratoolkit.current-ubuntu64.tar.gz \
&& cd sratoolkit.3.0.0-ubuntu64/bin/ \
&& ./vdb-config --interactive --interactive-mode textual \
CMD['63']
RUN cd /usr/local/ \
&& cp sratoolkit.3.0.0-ubuntu64/bin/fastq-dump-orig.3.0.0 /usr/local/bin/ \ 
&& chmod +x /usr/local/bin/fastq-dump-orig.3.0.0 \
&& apt-get remove -y wget gcc make libbz2-dev zlib1g-dev liblzma-dev libncurses-dev bzip2 \
&& apt-get autoremove -y \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
ENTRYPOINT ["/usr/local/bin/fastq-dump-orig.3.0.0"]
