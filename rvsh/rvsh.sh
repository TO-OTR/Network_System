#!/bin/bash

function login_log
{
    if ! [ -e './utmp.log' ]
    then
        : > './utmp.log'
    fi
    rv_utmp_log_line=($(grep -Fs "${rv_machine_name} ${rv_user_name}" './utmp.log'))
    if [ ${rv_utmp_log_line} ]
    then
        rv_utmp_log_tty=${rv_utmp_log_line[4]}
        rv_tty='pts/'$((${rv_utmp_log_tty#*/}+1))
    else
        rv_tty='pts/0'
    fi
    echo "${rv_machine_name} ${rv_user_name} $(date +%F) $(date +%T) ${rv_tty}" >> './utmp.log'
    
    rv_information_log=$(grep ^${rv_machine_name}$'\t'${rv_user_name} './information.log')
    rv_information_log=${rv_information_log#*$'\t'}; rv_information_log=${rv_information_log#*$'\t'}
    rv_server=${rv_information_log%$'\t'*}
    rv_remark=${rv_information_log#*$'\t'}
    rv_login_log=$(printf "%-8s %-8s %-8s %-8s %-19s %-30s %-15s\n" ${rv_user_name} ${rv_user_name} ${rv_tty} $(($RANDOM % 10)) "$(date +%F) $(date +%T)" "${rv_server}" ${rv_remark})
    rv_insert_command='1a\'
    sed -i "${rv_insert_command}${rv_login_log}" './login.log'
}

function logout_utmp_del_record
{
    sed -i "/${rv_machine_name} ${rv_user_name} .* pts\/${rv_tty:4}/d" './utmp.log'
}

rv_argument_line=(${*})
if [[ ${rv_argument_line} = '-admin' ]]
then
    rv_machine_name='rvsh'
    rv_user_name='root'
    echo 'Bienvenue à vous connecter "administrateur"! Veuillez entrer votre mot de passe (le mot de passe par défaut est "admin"):'
    read rv_password
    grep -Fxsq "${rv_user_name} ${rv_password} ${rv_machine_name}" './password'
    if [ ${?} = 0 ]
    then
        login_log
        while true
        do
            rv_message_file="${rv_machine_name}_${rv_user_name}.txt"
            if [ -e ${rv_message_file} ]
            then
                echo 'rvsh>'
                cat ${rv_message_file}
                rm -f ${rv_message_file}
            fi
			read -p 'rvsh>' rv_command rv_parameters
            case ${rv_command} in
            who)
                . ./who.sh
            ;;
            rusers)
                . ./rusers.sh
            ;;
            rhost)
                . ./rhost.sh
            ;;
            connect)
                . ./connect.sh ${rv_parameters}
            ;;
            su)
                #S'il n'y a pas de paraméters
                if [ -z ${rv_parameters} ]
                then
                    rv_parameters='root'
                fi
                . ./su.sh ${rv_parameters}
            ;;
            passwd)
                . ./passwd.sh
            ;;
            finger)
                . ./finger.sh
            ;;
            write)
                . ./write.sh ${rv_parameters}
            ;;
            host)
                . ./host.sh ${rv_parameters}
            ;;
            users)
                . ./users.sh ${rv_parameters}
            ;;
            #afinger machine_name user_name
            afinger)
                . ./afinger.sh ${rv_parameters}  
            ;;
            #Supprimer l'information ( en ligne ) dans utmp.log
            exit)
                logout_utmp_del_record
                exit
            ;;
            '')
                :
            ;;
            *)
                echo "${command} C'est la mauvaise commande!"
            ;;
            esac
        done
    else
        echo "C'est le mauvais mot de passe!"
    fi
elif [[ ${rv_argument_line[0]} = '-connect' ]]
then
    rv_machine_name=${rv_argument_line[1]}
    grep -Esq "^[^[:space:]]+ [^[:space:]]+ ${rv_machine_name}$" './password'
    if [ ${?} = 0 ]
    then
        rv_user_name=${rv_argument_line[2]}
        echo "Veuillez entrer le mot de passe pour ${rv_user_name}"
        read rv_password
        grep -Esq "${rv_user_name} [^[:space:]]+ ${rv_machine_name}" './password'
        if [ ${?} = 1 ]
        then
            echo "C'est le mauvais nom d'utilisateur!"
            exit
        fi
        grep -Fxsq "${rv_user_name} ${rv_password} ${rv_machine_name}" './password'
        if [ ${?} = 0 ]
        then
            login_log
            echo "Bienvenue ${rv_user_name}!"
            while true
            do
                rv_message_file="${rv_machine_name}_${rv_user_name}.txt"
                if [ -e ${rv_message_file} ]
                then
                    echo "${rv_user_name}@${rv_machine_name}>"
                    cat ${rv_message_file}
                    rm -f ${rv_message_file}
                fi
                read -p "${rv_user_name}@${rv_machine_name}>" rv_command rv_parameters
                case ${rv_command} in
                who)
                    . ./who.sh
                ;;
                rusers)
                    . ./rusers.sh
                ;;
                rhost)
                    . ./rhost.sh
                ;;
                connect)
                    . ./connect.sh ${rv_parameters}
                ;;
                su)
                    if [ -z ${rv_parameters} ]
                    then
                        rv_parameters='root'
                    fi
                    . ./su.sh ${rv_parameters}
                ;;
                passwd)
                    . ./passwd.sh
                ;;
                finger)
                    . ./finger.sh
                ;;
                write)
                    . ./write.sh ${rv_parameters}
                ;;
                exit)
                    logout_utmp_del_record
                    exit
                ;;
                '')
                    :
                ;;
                *)
                    echo "${command} C'est la mauvaise commande!"
                ;;
                esac
            done
        else
            echo "C'est le mauvais mot de passe!"
        fi
    else
        echo "C'est le mauvais nom de machine!"
    fi
else
    echo "C'est le mauvais paramètre!"
fi
