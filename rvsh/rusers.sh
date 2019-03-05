while read
do
    #Lire chaque ligne du fichier utmp.log et stocker la chaîne dans le tableau par défaut ${REPLY}
    rv_rusers_line=(${REPLY})
    #Echo le content
    echo "${rv_rusers_line[@]:0:4}"
#lire le fichier utmp.log
done < './utmp.log'
