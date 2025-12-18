#!/bin/bash

set -e

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
    ?)
      echo "Option inconnue !"
      exit 1
      ;;
  esac
done

echo "$USERNAME"
echo "$PASSWORD"
echo "$VERBOSE"