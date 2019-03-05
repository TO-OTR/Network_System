#Déterminer l'utilisateur actuel en tant qu'objet modifié
#Afficher le mot de passe actuel 
echo "Changer le mot de passe de ${rv_user_name}"
rv_passwd_passwordline=($(grep -Es "^${rv_user_name} [^[:space:]]+ ${rv_machine_name}$" './password'))
rv_passwd_password=${rv_passwd_passwordline[1]}
echo "(Maintenant) le mot de passe :${rv_passwd_password}"
rv_password_flag='false'
#rv_password_flag est pour assurer que les mots de passe entrés deux fois sont les mêmes
until [ ${rv_password_flag} = 'true' ]
do
    #Obtenir le nouveau mot de passe
    read -p 'Le nouveau mot de passe:' rv_passwd_password
    read -p 'Retaper le nouveau mot de passe:' rv_passwd_repassword
    #Confirmer le mot de passe à nouveau.
    if [ ${rv_passwd_password} = ${rv_passwd_repassword} ]
    then
        rv_password_flag='true'
        rv_passwd_comm="s/${rv_passwd_passwordline[@]}/${rv_user_name} ${rv_passwd_password} ${rv_machine_name}/"
        #Écrivez le nom d'utilisateur, le nom d'ordinateur et le mot de passe mis à jour dans le fichier
        sed -i "${rv_passwd_comm}" './password'
    else
        echo 'Les mots de passe entrés deux fois sont incohérents. Veuillez ré-entrer.'
    fi
done
