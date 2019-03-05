#${connect machine user}
rv_connect_machine_name=${1}
rv_connect_user_name=${2}
if ! [ ${rv_connect_user_name} ]
then
    rv_connect_user_name=${rv_user_name}
fi
#Obtenir le mot de password pour identifier
echo "Veuillez entrer le mot de passe pour ${rv_connect_user_name}"
read rv_connect_password
grep -Esq "${rv_connect_user_name} [^[:space:]]+ ${rv_connect_machine_name}" './password'
if [ ${?} = 0 ]
then
    grep -Fxsq "${rv_connect_user_name} ${rv_connect_password} ${rv_connect_machine_name}" './password'
    if [ ${?} = 0 ]
    then
        #Vérifier dans le fichier password. S’il exist le information, il va connecter.
        rv_machine_name=${rv_connect_machine_name}
        rv_user_name=${rv_connect_user_name}
        rv_password=${rv_connect_password}
        #Enregistrer les informations de connexion
        login_log
        echo "Bienvenue ${rv_user_name}!"
    else
        echo "C'est le mauvais mot de passe!"
    fi
else
    echo "C'est le mauvais nom de machine ou le nom d'utilisateur!"
fi
