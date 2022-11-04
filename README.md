# Projet_hackathon
RNAseq analysis

***ETAPE 1: Recuperation des identifiants des fichiers transcriptome

http://www.ncbi.nlm.nih.gov/sra?term=SRA062359

On a selectionné les fichiers transcriptomes pour générer un fichier contenant leurs identifiants (identiants_transcriptome.txt)

*****************************************DEBUT WORKFLOW*****************************************

***ETAPE 2: Téléchargements des 6 fichiers fastq

Le lien général pour télécharger ces séquences fastq est: 

https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID}
SRAID=identifiants 

==> Le process recup_data permet de récupérer toutes les sequences fastq compressé (format gz)
==> Une image docker est utilisée pour utiliser la commande fastq-dump. Cet image est disponible dans notre dockerhub. Pour la tester, fair la commande suivante:
    git pull maisenh/fatsq-dump:v3.0.4

***ETAPE 3: Récupération 





