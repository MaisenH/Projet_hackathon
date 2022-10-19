FROM r-base:4.2.0
 
COPY install_Deseq2.R .
RUN ["apt-get","update"]
RUN ["apt", "install", "-y", "libxml2-dev", "r-cran-xml", "libcurl4-openssl-dev", "libssl-dev"]
RUN ["Rscript", "install_Deseq2.R"]

CMD ["R"]