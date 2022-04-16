function help(){
    echo "usage:"
    echo "  borg.sh [options] "
    echo "options:"
    echo "list"
    echo "create + name"
    echo "delete + name"
    echo "reconfigure"

}
function reconfigure(){
    rm $FILE
    setup 
}
function list(){
    declare -a array
    i=0
    pwdlogin=0
    while IFS= read -r line; do
        #crop everything before = in $line
        a=$(echo $line | cut -d '=' -f2)
        if [[ $a == *password* ]]; then
            pwdlogin=1
        fi
        array[i]=$a
        i=$((i+1))
    done < $FILE
    if [ $pwdlogin == 1 ]; then
    
    else
        cmd="borg list ssh://${array[0]}@${array[1]}${array[2]}" 
    fi
}

function setup(){

    mkdir ~/.config/borghelper && touch ~/.config/borghelper/config.txt
    echo "tell me the user and password of the backup server"
    echo "user:"
    read user
    echo "ip or domain:"
    read ip
    echo "backup directory on the remote server"
    read backupdir
    echo "password or key login?"
    read pok
    if [ "$pok" = "password" ]; then
        echo "password:"
        read password
    else
        echo "keypath:"
        read key
    fi
    echo "user=$user" >> ~/.config/borghelper/config.txt
    echo "ip=$ip" >> ~/.config/borghelper/config.txt
    echo "backupdir=$backupdir" >> ~/.config/borghelper/config.txt
    if [ "$pok" = "password" ]; then
        echo "password=$password" >> ~/.config/borghelper/config.txt
    else
        echo "key=$key" >> ~/.config/borghelper/config.txt
    fi
}

FILE=~/.config/borghelper/config.txt
if test -f "$FILE"; then
    if [ "$1" = "reconfigure" ]; then
        reconfigure
    fi
    if [ "$1" = "list" ]; then
        list
    fi
else 
    setup 
fi

