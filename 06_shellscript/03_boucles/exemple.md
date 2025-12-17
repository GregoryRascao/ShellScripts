### Les Boucles 

Les boucles vont me permettre de parcourir chaque élément d'un tableau (la plus par du temps on couple les deux ensemble)
et exécuter une série d'opérations sur chaque élément de ce tableau.

#### Boucle for

```shell
files=$(ls -la .)

for file in $files
do
  echo file  
done
```

#### Boucle while

```shell
compteur=1

while [ $compteur. -le 5 ]
do
  echo "Generate file.$compteur"
  touch "file.$compteur"
  compteur=$((compteur + 1))
done
```