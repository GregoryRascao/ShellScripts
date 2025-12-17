compteur=1

while [ $compteur -le 5 ]
do
  echo "Generate file.$compteur"
  touch "file.$compteur"
  compteur=$((compteur + 1))
done

while read -p "Entrez les noms d'utilisateurs que vous voulez ajouter en DB" line
do
  # Si l'utilisateur n'a rien rentrer comme donnée
  if ! [ -n "$line" ]; then
    # le break me permet de stopper la boucle
    break
  fi
  echo "Ajoute l'utilisteur $line à la database"
done

while read line
do
  echo "La ligne contient $line"
done < file.txt