# Projet_hackathon

***ETAPE 1: Récuperation des identifiants des fichiers transcriptomes***

http://www.ncbi.nlm.nih.gov/sra?term=SRA062359

On a selectionné les fichiers transcriptomes pour générer un fichier contenant leurs identifiants (identiants_transcriptome.txt)

***ETAPE 2: Téléchargements des 8 fichiers fastq***

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

***ETAPE 4: Alignement (Mapping)***

* Le process Mapping permet d'aligner les reads (présents dans les fichiers fastq) sur le génome de référence à l'aide d'une annotation dejà faite que l'on récupère dans le process précédent.
* L'outil utilisé est le meme que dans le process précédent: star

***ETAPE 5: Indexation des fichiers bam avec samtools***
* Le process samtools permet d'indexer les fichiers bam => bai
* Une image docker a été créée pour utiliser la commande samtools. 
* Cette image est disponible dans un repository dans dockerhub. Pour la tester, fair la commande suivante:
    ```
    git pull staphb/samtools:latest
    ```

***ETAPE 6: Création de la table de comptage***
* Le process FeatureCounts permet de créer une table de comptage. Pour chaque gène (ligne de la table), le nombre de reads dans chaque conditions (colonne de la table) sera représenté.
* 
* Une image docker a été créée pour utiliser la commande featureCounts. 
* Cette image est disponible dans notre dockerhub. Pour la tester, fair la commande suivante:
    ```
    git pull maisenh/featurecounts:v2.0.0
    ```
    
***ETAPE 7: Analyse statistique***
* Le process AnalyseStat est séparé en deux. Il a permis de déterminer les gènes différenciellement exprimés entre les deux conditions(sain contre tumeur). La première partie va analyser les données et renvoyer des hitogrammes nous permettant d'évaluer la qualité de nos résultats. La deuxieme partie va permettre de récupérer les noms biologiques des gènes différenciellement exprimés.
* Une image docker a été créée pour utiliser la commande Deseq2 et biomaRt. 
* Cette image est disponible dans  un repository dans dockerhub.. Pour la tester, fair la commande suivante:
    ```
    git pull genomicpariscentre/deseq2:latest
    
    ```
    
    ```
    git pull  msgao/biomart
    ```
