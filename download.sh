##Telechargement des fichiers transcriptomes

if [ ! -d Fastq_file ];then
  mkdir Fastq_file
fi


cp identiants_transcriptome.txt Fastq_file/

cd Fastq_file/

fich="identiants_transcriptome.txt"

for ligne in $(<$fich)
do

  wget https://sra-pub-run-odp.s3.amazonaws.com/sra/${ligne}/${ligne} -O ${ligne}.sra
  docker run -v /Fastq_file:/tmp -w $PWD projet/sratoolkit:v3.0.0 fastq-dump-orig.3.0.0 --gzip --split-files ${ligne}.sra
  rm ${ligne}.sra
done
