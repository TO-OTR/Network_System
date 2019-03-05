rv_host_option=${1}
#Deux choix add/del
#ADD
if [ ${rv_host_option} = add ]
then
    rv_host_machine_name=${2}
    grep -Esq "^[^[:space:]]+ [^[:space:]]+ ${rv_host_machine_name}$" './password'
    if [ ${?} = 1 ]
    then
        rv_host_username=root
        echo "Entrez le mot de passe pour root"
        read rv_host_password
        echo "${rv_host_username} ${rv_host_password} ${rv_host_machine_name}" >> './password'
        echo "Fini"
    elif [ ${?} = 0 ]
    then
        echo "Le nom de la machine à ajouter existe déjà."
    fi
#DEL
elif [ ${rv_host_option} = del ]
then
    rv_host_machine_name=${2}
    grep -Esq "^[^[:space:]]+ [^[:space:]]+ ${rv_host_machine_name}$" './password'
    if [ ${?} = 0 ]
    then
	#supprimer tout le connection avec la machine
        sed -Ei "/^[^[:space:]]+ [^[:space:]]+ ${rv_host_machine_name}$/d" './password'
    elif [ ${?} = 1 ]
    then
        echo "Le nom de la machine à supprimer n'existe pas."
    fi
else
    echo "Il n'y a pas d'option ${rv_host_option}."
fi
