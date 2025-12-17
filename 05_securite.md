# Securité

## ACLs (Access Control Lists)

C'est une méthode qui va permettre d'aller plus loin que les règles standard posix
 Owner  Gr  Other
-rwx    rwx rwx

Récupérer les ACLs d'un fichier/dossier
```shell
getfacl hello.txt
```
```terminaloutput
# file: hello.txt
# owner: debian
# group: debian
user::rw-
group::r--
other::r--
```
```shell
ls -la hello.txt
```
```terminaloutput
-rw-r--r-- 1 debian debian 378 Dec 12 10:29 hello.txt
```

Voir si des ACLs sont appliquées avec ls :
```shell
ls -la hello.txt
```
```terminaloutput
-rw-r-xr--+ 1 debian debian   378 Dec 12 10:29 hello.txt
```
Le petit "+" signifie qu'il y a des droits supplémentaires aux POSIX classiques

#### Pour modifier des ACLs

1) Modifier un user : 
```shell
setfacl -m u:test:rw hello.txt 
```
```shell
getfacl hello.txt 
```
```terminaloutput
# file: hello.txt
# owner: debian
# group: debian
user::rw-
user:test:r--
group::r--
group:test:r-x
mask::r-x
other::r--
```

2) Modifier un groupe :
```shell
setfacl -m g:test:r hello.txt 
```
```shell
getfacl hello.txt
```
```terminaloutput
# file: hello.txt
# owner: debian
# group: debian
user::rw-
group::r--
group:test:r--
mask::r--
other::r--
```

```shell
setfacl -m g:test:rx hello.txt 
```
```shell
getfacl hello.txt
```
```terminaloutput
# file: hello.txt
# owner: debian
# group: debian
user::rw-
group::r--
group:test:r-x
mask::r-x
other::r--
```

3) Comme pour chmod, je peux appliquer une règles de manière récursive sur un dossier :
```shell
setfacl -R u:test:r dossier/
```

4) Retirer des droits :
```shell
setfacl -x u:test hello.txt
```
```shell
getfacl hello.txt 
```
```terminaloutput
# file: hello.txt
# owner: debian
# group: debian
user::rw-
group::r--
group:test:r-x
mask::r-x
other::---
```

```shell
setfacl -x g:test hello.txt
```
```shell
getfacl hello.txt 
```
```terminaloutput
# file: hello.txt
# owner: debian
# group: debian
user::rw-
group::r--
mask::r--
other::---
```

5) Droits par défaut :
Les droits par défaut sont applicable uniquement sur les dossier, ceux-ci vont permettre d'appliquer ces ACLs
comme valeur par défaut pour tout élément créé à l'intérieur du dossier.

```shell
setfacl -m d:u:test:rw shared/
```
```shell
setfacl -m d:g:dev:rw shared/
```

6) Mask
```shell
setfacl -m u:test:rwx test.sh
```
```shell
setfacl -m m:r test.sh
```
Ici l'utilisateur test aura les droits rwx, mais ne pourra qu'uniquement lire le fichier car le mask l'empêche d'avoir les droits write et execute.

## Sudo/Sudoers

Sudo (super user do) va me permettre d'exectuer une commande en tant qu'un autre utilisateur (root par défaut)
```shell
sudo cat /var/log/syslog 
```

Si le fichier /var/log/syslog n'est pas présent il faut installer rsyslog :
```shell
sudo apt install rsyslog
```

Par défaut on doit rajouter les utilisateurs au groupe sudo pour pouvoir utiliser sudo (sauf si on configure le sudoers)

En général on garde le groupe sudo pour les administrateur system

Je peux aussi préciser l'utilisalteur que je utiliser :
```shell
sudo -u USERNAME cat /home/USERNAME/private.txt
```

Préserver les variables d'environment (intéressent dans certains cas particulier dans un script) : 
```shell
sudo -E cat /var/log/syslog
```

Passer en tant qu'admin (root)
```shell
sudo su -
```

#### Gestion des droits dans le sudoers

```terminaloutput
root    ALL=(ALL:ALL)   ALL
```
Sigification

USER    HOSTS=(UTILISTEUR DONT ON PEUT PRENDRE L'IDENTITÉ)  COMMANDE_QUE_L'ON_PEUT_EXECUTER     

Si précédé d'un % alors la règle s'applique aux groupes

```shell
%sudo   ALL=(ALL:ALL)   ALL
```

Je peux préciser l'utilisateur qui pourra être utilisé en sudo : 

```shell
test  ALL=(debian)    ALL
```

Ici test ne peux qu'impersonner debian

```shell
test ALL=(root)   /usr/sbin/systemctl
```

Ici je précise que test ne peux utiliser que systemctl en tant que root.

```shell
test ALL=(root)   /usr/sbin/systemctl restart apache2
```

Ici je précise qu'il ne peux que faire un restart d'apache2 en tant que root.

```shell
test ALL=(devops) ALL,!/bin/rm
```

Ici test peux impersonner devops pour toutes les commandes sauf rm.

#### NOPASSWD

L'argument NOPASSWD va permettre de dire que l'on pourra executer sudo sans utiliser de mots de passe pour faire une ou plusieurs actions

!!! Éviter d'en abuser celà peut vite entrainer des problèmes de sécurité !!!

```shell
test ALL=(root)  NOPASSWD: /usr/sbin/systemctl restart apache2
```

Ici je précise que l'utilisateur test pourra executer la commade sans connaître le mots de passe du root.

#### Alias 

Je vais pouvoir faire des alias pour :

1) Les hotes
```terminaloutput
Host_Alias  SERVER_WEB=server1name,server2name
```
```terminaloutput
root    SERVER_WEB=(root)   ALL
```

2) les utilisateurs 
```terminaloutput
User_Alias  ADMINS = debian, bob
```
```terminaloutput
ADMINS    SERVER_WEB=(root)   ALL
```

3) les commandes
```terminaloutput
Cmnd_Alias  MAINTENANCE = /usr/bin/apt, /usr/sbin/systemctl
```
```terminaloutput
ADMINS    SERVER_WEB=(root)   MAINTENANCE,TEST
```

#### Voir les logs

```shell
sudo cat /var/log/auth.log
```
```shell
sudo journalctl -t sudo
```

## Firewall

Un parfeu va permettre de filtrer le trafic réseau entrant en définissant des règles pour dire ce qui peut passer ou pas.

Sur linux il y a 4 parefeu qu'on peut utliser : 
- iptables : le parefeu historique de linux
- nftables : le nouveau parefeu officiel de linux
- ufw : Un surcouche à iptables ou nftables pour les systèmes basé Debian (simplifie l'utilisation)
- firewalld : Même chose que ufw mais pour les système basé redhats

#### 1. Ufw

1) Voir le status
```shell
sudo ufw status verbose
```
```terminaloutput
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
80/tcp (WWW)               ALLOW IN    Anywhere                  
22/tcp                     ALLOW IN    Anywhere                  
22                         ALLOW IN    Anywhere                  
80,443/tcp (WWW Full)      ALLOW IN    Anywhere                  
80/tcp (WWW (v6))          ALLOW IN    Anywhere (v6)             
22/tcp (v6)                ALLOW IN    Anywhere (v6)             
22 (v6)                    ALLOW IN    Anywhere (v6)             
80,443/tcp (WWW Full (v6)) ALLOW IN    Anywhere (v6)
```

Ici on a deux fois les règles car on a une règle pour IPv4 et la même règle pour IPv6

2) Pour activer ufw
```shell
sudo ufw enable
```

3) Pour le désactiver
```shell
sudo ufw disable
```

4) Créer une nouvelle règle
```shell
sudo ufw allow ssh
```
ou
```shell
sudo ufw allow 22/tcp
```
Ici j'authorise le trafic ssh (port 22)

Pareil pour http :
```shell
sudo ufw allow http
```
ou 
```shell
sudo ufw allow 80
```

5) Bloquer un port
```shell
sudo ufw deny 3306
```
Ne pas authorisé les connection sur le port 3306 (mysql)

7) supprimer une règle :
```shell
sudo ufw delete allow 22
```
je supprime l'authorisation de se connecter en ssh

8) Limiter la connexion (anti-bruteforce)
```shell
sudo ufw limit ssh
```

#### Firewalld

1) Voir le status
```shell
sudo firewall-cmd --state
```

```shell
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --list-all
```

Ici on a deux fois les règles car on a une règle pour IPv4 et la même règle pour IPv6

2) Pour activer ufw
```shell
sudo systemctl enable firewalld
sudo systemctl start firewalld
```

3) Pour le désactiver
```shell
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```

4) Créer une nouvelle règle
```shell
sudo firewall-cmd --permanent --add-port=22/tcp
sudo firewall-cmd --reload
```
Ici j'authorise le trafic ssh (port 22)

5) Bloquer un port
```shell
sudo firewall-cmd --permanent --remove-port=3306/tcp
sudo firewall-cmd --reload
```
Ne pas authorisé les connection sur le port 3306 (mysql)

#### IPTables

1) voir les règles
```shell
sudo iptables -L -v -n
```

2) Bloquer tout le trafic entrant
```shell
sudo iptables -P INPUT DROP
```

3) Authorisé un port
```shell
sudo ipables -A INPUT -p tcp --dport 22 -j ACCEPT
```

4) Sauver les règles (ipv4)
```shell
sudo iptables-save > /etc/iptables/rules.v4
```

####  nftables

1) lister les règles
```shell
sudo nft list ruleset
```

2) Ajouter une règle
```shell
sudo nft add rule inet filter input tcp dport 22 accept
```

3) bloquer tout le reste
```shell
sudo nft add rule inet filter input drop
```

## SSH

SSH est un protocol de connexion à distance sur un serveur (Linux et Windows)

C'est un protocol qui fonctionne avec la ligne de commande

1) Installation
```shell
sudo apt install ssh
```

2) Vérifier qu'il tourne
```shell
systemctl status ssh
```

3) Configurer ssh
```shell
cat /etc/ssh/ssh_config
```
```terminaloutput
# This is the ssh client system-wide configuration file.  See
# ssh_config(5) for more information.  This file provides defaults for
# users, and the values can be changed in per-user configuration files
# or on the command line.

# Configuration data is parsed as follows:
#  1. command line options
#  2. user-specific file
#  3. system-wide file
# Any configuration value is only changed the first time it is set.
# Thus, host-specific definitions should be at the beginning of the
# configuration file, and defaults at the end.

# Site-wide defaults for some commonly used options.  For a comprehensive
# list of available options, their meanings and defaults, please see the
# ssh_config(5) man page.

Include /etc/ssh/ssh_config.d/*.conf

Host *
#   ForwardAgent no
#   ForwardX11 no
#   ForwardX11Trusted yes
#   PasswordAuthentication yes
#   HostbasedAuthentication no
#   GSSAPIAuthentication no
#   GSSAPIDelegateCredentials no
#   GSSAPIKeyExchange no
#   GSSAPITrustDNS no
#   BatchMode no
#   CheckHostIP yes
#   AddressFamily any
#   ConnectTimeout 0
#   StrictHostKeyChecking ask
#   IdentityFile ~/.ssh/id_rsa
#   IdentityFile ~/.ssh/id_dsa
#   IdentityFile ~/.ssh/id_ecdsa
#   IdentityFile ~/.ssh/id_ed25519
#   Port 22
#   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc
#   MACs hmac-md5,hmac-sha1,umac-64@openssh.com
#   EscapeChar ~
#   Tunnel no
#   TunnelDevice any:any
#   PermitLocalCommand no
#   VisualHostKey no
#   ProxyCommand ssh -q -W %h:%p gateway.example.com
#   RekeyLimit 1G 1h
#   UserKnownHostsFile ~/.ssh/known_hosts.d/%k
    SendEnv LANG LC_*
    HashKnownHosts yes
    GSSAPIAuthentication yes
```

Si je veux par exemple ne plus authorisé les connexions avec mots de passe (c-a-d où on demande le mots de passe à l'utilisateur lors de la connexion)

```terminaloutput
#   PasswordAuthentication yes
```
```terminaloutput
    PasswordAuthentication no
```

Autre paramètre intéressent : 
```terminaloutput
Host *
```
Ici je vais pouvoir filtrer les hosts qui peuvent se connecter à cette machine
```terminaloutput
Host 10.3.?.?
```
ou
```terminaloutput
Host dev.test.local
```
ou 
```terminaloutput
Host dev
    HostName dev.local
    User bob
```

De cette manière on ne pourra plus que se connecter avec une paire de clé connue du serveur.

!!! Si vous n'avez pas déposer votre clé publique dans le dossier approprié vous ne saurez plus vous conecter en ssh !!!

Gestion des clés
```shell
ssh-keygen
```

Ici il va nous demander où on enregistre les clés (par défaut il le fait dans ~/.ssh/id_rsa et ~/.ssh/id_rsa.pub)

Ensuite il demande une passephrase (mots de passe pour utiliser la clé)

Dans les bonnes pratiques il est conseillés de faire une rotation de clés (changer de clés ssh) tous les ~6mois

!!! Attention lors d'une rotation conserver vos anciennes clés privées/publique le temps de changer celles-ci sur les serveur !!!

Cette commande génère deux clés : 
- id_rsa => clé privée (à conserver sur votre machine et à ne jamais partager!)
- id_rsa.pub => clé publique (à déposer sur les seveurs)

Exemple de clé publique
```terminaloutput
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/+wKYF7tVz+PygV9c7vMe8ctLHY423V+r/GOTNzGPz8gGSRgLbJQdJpkzPEiVlF3+yePuSW70I1cPblkQqLvoktKXgsHhjCCs1aFH5TEEsyTKuIOpN0Aa87META/oUS4fIXie95rLM7kI9Ducyx+gRc+4KtyuBktYjDRTNFPVyc0vgvxGJM1jWa9bqESeBQ9rwnLfidF3JmSMB1a7lM0zberWmThgPS087BEmm3Nxi73lp8C6F3d8wL4GtMqU9lkEwCjLNFqURGA6BRqoipBWSyuWRXY8x8mTrMwp00R0YFTu0y6+ATgxPyOjOWP7BGp/a7Ioo9iMls+rL1G8+z0Gpvg068Q4Llpna7P+fAZegn/Sox0eQaeTFQKCUCY5zEIYTWFdFAfbd/r+zljvT9SIw4l+ohYov7QmwLKPAyTts4jyKEehhJYWRFy8ZwbXitJHtn7B3ZXflXEIzR3oRMNm0r75DJ1+ELfLf4MpSA7JDxjzEg7eC9IluHSr7pCcZkk= debian@balrog-c2-srv
```

#### S'authentifier avec une paires de clés

il faudra déposer votre clé publique sur le serveur dans le fichier ~/.ssh/authorized_keys, ce fichier peux contenir plusieurs clés publique
celles-ci doivent juste être collées l'une après l'autres et terminées par un retour à la ligne (sauf la dernière)

Une fois qu'on a copier sa clé on pourra se connecter sans mots de passe.

passer les authorized key avec la bonne permission
```shell
chmod 600 .ssh/authorized_keys
```

On peut aussi copier automatiquement sa clé via la commande : 
```shell
ssh-copy-id username@server
```

#### Se connecter

Via une address ip
```shell
ssh username@xxx.xxx.xxx.xxx
```

Récupérer une l'adresse IP (privée) du serveur :
```shell
ip addr
```

via un nom de domaine : 
```shell
ssh username@devopsbf.be
```
Vous pouvez créer des noms de domaines custom dans le fichier hosts (/etc/hosts, C:\Windows\System32\driver\etc\hosts)

Pour ce faire il faut juste rajouter une ligne 

```terminaloutput
ADDRESS_IP      nom.de.domaine
```

!!! Le fichier hosts a priorité sur le DNS, donc si vous mettez :
```terminaloutput
127.0.0.1      www.google.com
```
à chaque fois que vous tenterez de vous connecter à google, vous serez rediriger vers votre propre machine.
Donc faites bien attention aux noms de domaines que vous entrez pour les machines (serveurs) concerné.

Exemple :
```terminaloutput
ADDRESS_IP      bf.devops25
```

Donc ici la connection sera : 
```shell
ssh username@bf.devops25
```

## AppArmor/SELinux
