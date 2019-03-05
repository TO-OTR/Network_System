#Touts les utilisateurs connectés sur la machine maintenant
while read
do
    #Lire chaque ligne du fichier utmp.log et stocker la chaîne dans le tableau par défaut ${REPLY}
    rv_who_line=(${REPLY})
    #Si le nom de la machine correspond à la machine actuelle, echo le content
    if [ ${rv_who_line[0]} = ${rv_machine_name} ]
    then
        echo "${rv_who_line[@]:0:4}"
    fi
#lire le fichier utmp.log
done < './utmp.log'
