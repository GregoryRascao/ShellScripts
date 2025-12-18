### Les arguments

Les arguments sont ce qui suit la commande qu'on exécute

```shell
ls -la /dev
```
Ici les arguments sont : 

| arguments | nom |
|-----------|-----|
| ls        | $0  |
| -la       | $1  |
| /dev      | $2  |

Récupérer les arguments 
```shell
#!/bin/bash

echo "Nom du script : $0"
echo "Argument 1 : $1"
echo "Argument 2 : $2"
echo "Argument 3 : $3"
echo "Argument 4 : $4"
echo "Argument 5 : $5"
echo "Argument 6 : $6"
echo "etc"
```

#### Savoir le nombre d'arguments

```shell
#!/bin/bash

echo $#
```

#### Récupérer le tableau des arguments

```shell
#!/bin/bash

echo $@
```

#### Récupérer la chaine de caractère contenant tous les arguements

```shell
#!/bin/bash

echo $*
```

### Parsion d'arguments

```shell
#!/bin/bash

# Syntaxe
# while getopts "options" NOM_VARIBLE; 
# do
#   case "$NOM_VARIABLE" in
#   ....
#   esac
# done

while getopts "hv" OPS;
do
  case "$OPS" in
    h)
      echo "afficher l'aide"
      exit 0
      ;;
    v) 
      echo "Activer le mode verbose"
      ;;
    *)
      echo "Option inconnue ! $OPS"
      exit 1
      ;;
done
```

Ici si je fais :
```shell
./script.sh -h
```
la sortie sera : 
```terminaloutput
affichier l'aide
```

Ici si je fais :
```shell
./script.sh -v
```
la sortie sera :
```terminaloutput
Activer le mode verbose
```

Ici si je fais :
```shell
./script.sh -r
```
la sortie sera :
```terminaloutput
Option inconnue ! -r
```


#### Syntaxe des options 

```shell
# je présice -h -v
getopts "hv"
# Ici je précise que -u et -p seront suivit d'une valeur qui sera l'argument suivant.
getopts "u:p:hv" 
```

```shell
#!/bin/bash

VERBOSE=false
ERRORS=()

while getopts "u:p:hv" OPS;
do
  case "${OPS}" in
    u)
      # le $OPTARG me permet de récupérer la valeur de l'argument suivant
      echo "username $OPTARG"
      USERNAME=${OPTARG}
      ;;
    p)
      echo "password $OPTARG"
      PASSWORD=${OPTARG}
      ;;
    h)
      echo "afficher l'aide"
      exit 0
      ;;
    v) 
      echo "Activer le mode verbose"
      VERBOSE=true
      ;;
    *)
      echo "Option inconnue '$OPS' !"
      exit 1
      ;;
  esac
done
```

#### Vérifier la présence d'un argument dans un argument via un if

```shell
# Ici je regarde si la chaine d'arguments contient -v
if [ $* == *-v*];
then
  VERBOSE=true
fi
```

