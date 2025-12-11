### Permission POSIX

Les perssion de base 
```
-rwxr-xr-- 1 username usergroup 219K May 15  2020 script.sh

r = read
w = write
x = execute

le premier groupe sont les permission de l'utilisateur possèdant le fichier (ici username)
le second sont les permissions du groupe de l'utilisateur (ici usergroup)
et le troisième groupe sont les permission des autres utilisateurs.

Donc dans ce cas ci :
l'utilisateur "username" peut lire/écrire/executer le fichier
les membres de "usergroup" peuvent lire et executer
les autres ne peuvent que lire le fichier
```

Pour les dossier : 
```
drwxr-xr-- 1 username usergroup 219K May 15  2020 dossier

d = directory (dossier)
r = read
w = write
x = execute

Pour les dossier, le droit de lecture permettera de faire un ls pour voir le contenu.
Le droit d'écriture me permet d'ajouter/modifier des fichiers/sous-dossier, dans le dossier
Et le droit d'exécution me permet d'accèder (cd) dans le dossier.
```

### Pour modifier les permissions

```
Les permission sont codées en octal (chiffre allant de 0 à 7) ou :
1 = execution
2 = écriture
4 = lecture 

et je vais donc pouvoir associés ces chiffres ensemble pour set des permissions
7 = rwx
6 = rw-
5 = r-x
4 = r--
3 = -wx
2 = -w-
1 = --x
```

```bash
chmod 700 script.sh

ou 

chmod u=rwx,g=,o= myfile
```
avant :

-rwxr-xr-- 1 username usergroup 219K May 15  2020 script.sh

après : 

-rwx------ 1 username usergroup 219K May 15  2020 script.sh

```bash
chmod 664 script.sh

ou 

chmod u=rw,grw=,o=r myfile
```

avant :

-rwx------ 1 username usergroup 219K May 15  2020 script.sh

après :

-rw-rw-r-- 1 username usergroup 219K May 15  2020 script.sh

### Modifier plusieurs fichiers en un coup

```bash
chmod 700 *.sh
```

### Modifier un dossier et donner les mêmes permissions aux enfants

```bash
chmod -R 700 dossier/
```

### Persmissions spéciales : 

```
rws = s => SUID ou SGID me permet de momentanément récupérer les droits de
l'utilisateur ou le groupe possèdant le fichier pendant l'exécution  
```

```bash
chmod g+s file.sh

ou

chmod u+s file.sh
```

pour le retirer

```bash
chmod g-s file.sh

ou

chmod u-s file.sh
```

```
ls / 
```
```
résultat
lrwxrwxrwx   1 root root    7 Dec  2  2024 bin -> usr/bin

analyse
lrwxr--r-- = l => lien symbolique
```
Dans l'exemple précédent le /bin redirige vers le /usr/bin

### Changer l'utilisateur 

```bash
chown newusername file
```
avant :

-rw-rw-r-- 1 username usergroup 219K May 15  2020 file

après : 

-rw-rw-r-- 1 newusername usergroup 219K May 15  2020 file

### Changer le groupe de l'utilisateur 

```bash
chgrp newgroup file
```
avant :

-rw-rw-r-- 1 username usergroup 219K May 15  2020 file

après :

-rw-rw-r-- 1 username newgroup 219K May 15  2020 file
