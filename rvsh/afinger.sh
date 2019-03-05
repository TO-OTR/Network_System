#Un tableau de chaînes
rv_afinger_machine_name=${1}
rv_afinger_user_name=${2}
echo "S'il vous plaît entrer le mot de passe pour ${rv_afinger_user_name}"
#Vérifier le mot de passe
read rv_afinger_password
grep -Esq "${rv_afinger_user_name} [^[:space:]]+ ${rv_afinger_machine_name}" './password'
if [ ${?} = 0 ]
then
    grep -Fxsq "${rv_afinger_user_name} ${rv_afinger_password} ${rv_afinger_machine_name}" './password'
    if [ ${?} = 0 ]
    then
        echo "S'il vous plaît entrer le serveur"
        read rv_afinger_server
        echo "S'il vous plaît entrer les remarques"
        read rv_afinger_remark
        #Utiliser un tableau de chaînes pour stocker des informations
        rv_afinger_information_log=${rv_afinger_machine_name}$'\t'${rv_afinger_user_name}$'\t'"${rv_afinger_server}"$'\t'${rv_afinger_remark}
        #Écrire dans infomation.log
        if ! [ -e './information.log' ]
        then
            : > './information.log'
        fi
        grep ^${rv_afinger_machine_name}$'\t'${rv_afinger_user_name} './information.log'
        if [ ${?} = 0 ]
        then
            #Pour écraser les anciennes informations avec de nouvelles informations
            sed -i s/^${rv_afinger_machine_name}$'\t'${rv_afinger_user_name}.*$/"${rv_afinger_information_log}"/ './information.log'
        else
            echo "${rv_afinger_information_log}" >> './information.log'
        fi
        
    else
        echo "C'est le mauvais mot de passe!"
    fi
else
    echo "Ceci est un nom de machine ou un nom d'utilisateur incorrect!"
fi
