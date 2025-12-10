# Introduction au shellscript 

## Commandes Linux importantes 

### Navigation dans le terminal

afficher l'emplacement actuel dans le terminal 
```bash
pwd 
```

Se déplacer dans le terminal 
```bash
cd NomDuDossier
```
Se déplacer dans le dossier parent
```bash
cd ..
```
Se déplacer dans un dossier dans le dossier parent 
```bash
cd ../NomDuDossier
```

### Manipulation de fichiers/dossiers

Créer un fichier 
```bash
touch nomDuFichier
```

Supprimer un ficher 
```bash
rm nomDuFichier
```

Créer un nouveau dossier 
```bash
mkdir nomDuDossier
```

Supprimer un dossier 
```bash
rmdir nomDuDossier
```

```bash
rm -Rf nomDuDossier
```

Déplacer un fichier ou un dossier
```bash
mv ./origine nouvelle/emplacement/
```
Cette commande va déplacer le fichier origine (dans le dossier courant)
dans le dossier ./nouvel/emplacement/origine

Renomer un dossier ou fichier
```bash
mv ancienNom nouveauNom
```

Copier un fichier
```bash
cp origine copie
```
crée un nouveau fichier nommé copie avec le même contenu que origine

Copier un dossier
```bash
cp -R origine/ nouveauDossier/
```

### Redirection des sorties

rediriger toutes les sorties d'une commandes dans un fichier
```bash
echo "Hello" > example.txt
```
Ou
```bash
echo "Hello" >> example.txt
```

La différence entre > et >> est que > redirigera la sortie et écrasera le contenu du fichier la ou >> va écrire à la ligne suivante

Celà fonctionne aussi avec des commandes 
```bash
ls >> files.txt
```

Je peux aussi uniquement rediriger les erreurs
```bash
ls 2> errors.txt
```

### Afficher le contenu d'un fichier 

```bash
cat filename.txt
```

Si je veux n'afficher que les 10 premières lignes :
```bash
head filename
```

Afficher les 10 dernières lignes 
```bash
tail filename
```

Afficher les n (ici 5) premières lignes :
```bash
head -n 5 filename
```
```bash
tail -n 5 filename
```

### Éditer un fichier 

Deux éditeurs sont disponibles nativement sur la plus part des distributions linux:
```bash
nano filename
```
#### Raccourcis utiles dans nano :

CTRL + O → Enregistrer

CTRL + X → Quitter

CTRL + K → Couper une ligne

CTRL + U → Coller la ligne coupée

CTRL + W → Chercher du texte

*CTRL + * → Remplacer du texte

```bash
vim filename
```

#### Dans vim, trois modes importants :

Normal (défaut)

Insertion → appuie sur i

Commande → appuie sur :

#### Ajouter du texte

Ouvre vim

Appuie sur i

Tape ton texte

ESC pour revenir au mode normal

:wq ou :x pour enregistrer et quitter 

Sur debian et d'autres distribution il se peut que vim ne soit pas installer mais que vi (son ancêtre le soit)

### Redirection avec EOF 

```bash
cat <<EOF >> output.txt
le contenu que je veux dans mon fichier
je peux faire des retours à la ligne
etc
...
...
...
et cloture le fichier avec :
EOF
```
### Envoyer la sortie d'une commande comme entrée d'une autre 

Pour ce faire on utilise le | qui permet de rediriger 
la sortie d'une commande comme entrée d'une autre. 

Par exemple ici je cherche à extraire toutes les lignes contenant "sha-256"
```bash
cat /etc/postgresql/15/main/pg_hba.conf | grep sha-256
```

Un autre exemple trié une sortie
```bash
ls / | sort
```

Ici je compte le nombre de ligne contenant "sha-256" dans le fichier pg_hba.conf
```bash
cat /etc/postgresql/15/main/pg_hba.conf | grep sha-256 | wc -l
```

### Gestion des processus 

Afficher les processus en cours d'exécution :
```bash
ps aux
```

Interactif : 
```bash
top
```

Ou encore mieux :
```bash
htop
```

#### Si je veux chercher un processus en cours d'exécution (exemple node)

```bash
ps aux | grep node
```

Une fois que j'ai le PID (process ID) du processus je peux par exemple le tuer : 
```bash
kill -9 PID
```
