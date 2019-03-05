#La commande trap peut spécifier le signal Linux que le script shell doit surveiller et intercepter.
#Surveiller s'il y a une entrée ^c
function onCtrlC
{
    rv_write_abort_flag='true'
    trap - INT
}

rv_write_user_name=${1%@*}
rv_write_machine_name=${1#*@}
#Le fichier est pour stocker le message
rv_write_message_file="${rv_write_machine_name}_${rv_write_user_name}.txt"
#write user2@mach2 01 02 03 04 05
#couper la string "user2@mach2 this is a" => "this is a"
rv_write_greeting=${@#*' '}
rv_write_greeting=${rv_write_greeting#*' '}
#Stocker les destinataires et le temps
echo "Message pour ${rv_write_user_name}@${rv_write_machine_name} sur pts/0, temps: $(date +%T), date: $(date +%F)" >> ${rv_write_message_file}
echo "${rv_write_greeting}" >> ${rv_write_message_file}

echo "Taper ^ c pour finir"
trap onCtrlC INT
rv_write_abort_flag='false'
while [ ${rv_write_abort_flag} = 'false' ]
do
    #stocker le message dans le fichier temporaire
    read rv_write_message
    echo ${rv_write_message} >> ${rv_write_message_file}
done
