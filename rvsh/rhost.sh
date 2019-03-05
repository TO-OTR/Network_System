while read
do
    #Lire chaque ligne du fichier utmp.log et stocker la chaîne dans le tableau par défaut ${REPLY}
    rv_rhost_line=(${REPLY})
    #Echo le content (machin_name)
    echo "${rv_rhost_line[0]}"
#lire le fichier utmp.log
done < './utmp.log'
