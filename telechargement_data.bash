

##Telechargement des fichiers transcriptomes

if [ ! -d Fastq_file ];then
  mkdir Fastq_file
fi


fichier="identiants_transcriptome.txt"

cp fichier Fastq_file/

for ligne in $(<$fichier)
do
   wget -o "https://trace.ncbi.nlm.nih.gov/Traces/sra-reads-be/fastq?acc=${ligne}" Fastq_file/ 
done
