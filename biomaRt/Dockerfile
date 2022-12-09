FROM r-base:4.2.0
 
COPY install_biomaRt.R .

RUN ["Rscript", "install_biomaRt.R"]

CMD ["R"]
