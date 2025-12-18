### Récupérer le code d'erreur de commandes lancées 

```shell
#!/bin/bash

# En imaginant que fichier1 n'extiste pas.
cp fichier1 fichier2

# Je vais pouvoir récupérer le code d'erreur de la dernère commande lancée via $?

if [ $? -ne 0 ];
then
  echo "Error lors de la copie"
  exit 1  
fi
```

### Arrêter le script automatiquement lors d'une erreur.

```shell
#!/bin/bash

# Via le set -e, je précise d'arrêter le script en cas d'erreur
set -e
```

### Désactier temporairement le set -e 

```shell
#!/bin/bash 

# set -x permet de désactiver l'arrêt en cas d'erreurs.
set -x 
```

```shell
#!/bin/bash 

touch one
# Je désactive le fait d'arrêter en cas d'erreur pour l'instruction touch two
(
  set -x
  touch two
)
touch three

```

### Faire des sorties en tant qu'erreur

```shell
#!/bin/bash

echo "Un message normal d'information"
echo "Un message d'erreur" >&2 
```

### Gestion des erreurs simple avec || 

```shell
# Si je sais qu'une commande peux créer des erreurs mais est sans impacte pour l'exécution 
# Typiquement on fait ça avec mkdir

# Si la directory existe déjà cette commande va planter.
mkdir ./new_directory

# Ici même si la directory existe déjà, le script continue de s'exécuter.
mkdir ./new_directory || true


# Je peux aussi Faire l'inverse, c-a-d executer quelque chose en cas d'erreur
mkdir ./new_directory || {
  echo "Impossible de créer le dossier !"
  exit 1
}
```