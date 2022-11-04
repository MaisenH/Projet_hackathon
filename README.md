# Projet_hackathon

***ETAPE 1: Récuperation des identifiants des fichiers transcriptomes***

http://www.ncbi.nlm.nih.gov/sra?term=SRA062359

On a selectionné les fichiers transcriptomes pour générer un fichier contenant leurs identifiants (identiants_transcriptome.txt)

***ETAPE 2: Téléchargements des 6 fichiers fastq***

Le lien général pour télécharger ces séquences fastq est: 

https://sra-pub-run-odp.s3.amazonaws.com/sra/${SRAID}/${SRAID} 

* Le process recup_data permet de récupérer toutes les sequences fastq compressé (format gz)
* Une image docker a été créée pour utiliser la commande fastq-dump. 
* Cette image est disponible dans notre dockerhub. Pour la tester, fair la commande suivante:


    ```
    git pull maisenh/fatsq-dump:v3.0.4
    ```

***ETAPE 3: Récupération Génome et annonation***

* Le process Getinfo permet de récupérer:
    * Le génome en entier:
    
    ```
    wget ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.*.fa.gz
    ```
    
    
    * L'annotation:


    ```
    wget ftp://ftp.ensembl.org/pub/release-101/gtf/homo_sapiens/Homo_sapiens.GRCh38.101.chr.gtf.gz
    ```
* Une image docker a été créée pour utiliser la commande star. 
* Cette image est disponible dans notre dockerhub. Pour la tester, fair la commande suivante:
    ```
    git pull maisenh/star:v0.1
    ```
    
L'ensemble des images que nous avons fait sont disponibles également dans notre repository git.

