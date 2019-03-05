rv_users_option=${1}
#Deux choix add/del
if [ ${rv_users_option} = add ]
then
    echo "Entrez le nom de la machine dans laquelle vous voulez mettre l'utilisateur"
    read rv_users_machine_name
    #Vérifier le fichier password  si le nom de la machine existe déjà ou non
    grep -Esq "^[^[:space:]]+ [^[:space:]]+ ${rv_users_machine_name}$" './password'
    if [ ${?} = 0 ]
    then
        rv_users_user_name=${2}
        #Vérifier le fichier password si le nom d'utilisateur existe déjà ou non.
        grep -Esq "^${rv_users_user_name} [^[:space:]]+ ${rv_users_machine_name}$" './password'
        if [ ${?} = 1 ]
        then
            echo "Tapez votre mot de passe"
            read rv_users_password
            echo "${rv_users_user_name} ${rv_users_password} ${rv_users_machine_name}" >> './password'
        elif [ ${?} = 0 ]
        then
            echo "Le nom d'utilisateur à ajouter existe déjà."
        fi
    elif [ ${?} = 1 ]
    then
        echo "Le nom de la machine ${rv_users_machine_name} n'existe pas."
    fi
elif [ ${rv_users_option} = del ]
then
    rv_users_user_name=${2}
    grep -Esq "^${rv_users_user_name} [^[:space:]]+ [^[:space:]]+$" './password'
    if [ ${?} = 0 ]
    then
        #Supprimer tout le connection avec la machine
        echo "Entrez le nom de la machine que vous voulez mettre dans l'utilisateur"
        read rv_users_machine_name
        grep -Esq "^[^[:space:]]+ [^[:space:]]+ ${rv_users_machine_name}$" './password'
        if [ ${?} = 0 ]
        then
            sed -Ei "/^${rv_users_user_name} [^[:space:]]+ ${rv_users_machine_name}$/d" './password'
        fi
    elif [ ${?} = 1 ]
    then
        echo "Le nom d'utilisateur à supprimer n'existe pas."
    fi
else
    echo "Il n'y a pas d'option ${rv_users_option}."
fi
