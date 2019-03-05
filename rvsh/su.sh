rv_su_user_name=${1}
echo "Veuillez entrer le mot de passe pour  ${rv_su_user_name}"
read rv_su_password
#Vérifier le mot de passe
#Vérifier la combinaison de l'utilisateur et de la machine
grep -Esq "^${rv_su_user_name} [^[:space:]]+ ${rv_machine_name}$" './password'
if [ ${?} = 0 ]
then
    grep -Fxsq "${rv_su_user_name} ${rv_su_password} ${rv_machine_name}" './password'
    if [ ${?} = 0 ]
    then
        #passer des paramètres
        rv_user_name=${rv_su_user_name}
        echo "Bienvenue ${rv_su_user_name}!"
    else
        echo "C'est le mauvais mot de passe!"
    fi
else
    echo "C'est le mauvais nom d'utilisateur!"
fi
