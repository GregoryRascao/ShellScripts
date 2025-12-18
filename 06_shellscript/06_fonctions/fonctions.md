### Les fonctions

Le but d'une fonction est de permettre d'exécuter une partie de code stockée dans ce qu'on appelle une fonction
plusieurs fois dans le script sans devoir retaper celui-ci

```shell
#!/bin/bash

print_help() {
  echo " Usage : "
  echo "./command_name.sh -u username -p password -v"
  echo "\t-u \t username followed by the username"
  echo "\t-p \t password followed by the user password"
  echo "\t-h \t prompt this message"
  echo "\t-v \t enable verbose mode"
}

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
      print_help
      exit 0
      ;;
    v) 
      echo "Activer le mode verbose"
      VERBOSE=true
      ;;
    *)
      print_help
      exit 1
      ;;
  esac
done
```

#### Les arguments des fonctions

```shell
#!/bin/bash

hello_fct() {
  echo "Hello $1"
}

hello_fct "Philippe"
hello_fct "Bob"
```

#### Importer des fonctions d'un autre script 

```shell
#!/bin/bash

# Importera les fonctions du script fonctions.sh
source ./fonctions.sh
```