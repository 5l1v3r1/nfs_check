clear
ip=$1
echo
echo "o   o o--o  o-o       o             o    "
echo "|\  | |    |          |             | /  "
echo "| \ | O-o   o-o   o-o O--o o-o  o-o OO   "
echo "|  \| |        | |    |  | |-' |    | \  "
echo "o   o o    o--o   o-o o  o o-o  o-o o  o v0.1"
                                         
if [ `id -u` -eq 0 ]; then
	if [ -n "$ip" ]; then
		echo
		echo -e "\e[40;38;5;82m RPC \e[30;48;5;82m INFO \e[0m"
		echo
		rpcinfo -p $ip

		e=$(showmount -e $ip | grep "*")

		if [ -n "$e" ]; then
			echo
			echo -e "\e[40;38;5;82m SHOW \e[30;48;5;82m MOUNT \e[0m"
			echo
			for i in {16..21} {21..16} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
			showmount -e $ip
			for i in {16..21} {21..16} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
			showmount -a $ip
			for i in {16..21} {21..16} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
			showmount -d $ip
			for i in {16..21} {21..16} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
			echo 
			echo -e "\e[40;38;5;82m MOUNT \e[30;48;5;82m NOW \e[0m"
			echo

			list=(`showmount -e $ip | grep '*' |awk '{print $1}'`)
			cont=$(showmount -e $ip | grep '*' |awk '{print $1}'|wc -l)
			path=0
			change="_"
			finds="/"
			read -p "Do you want to mount the directory (Y/n)? " opc
			echo
			if [ "$opc" = "y" ]; then
				echo "Loading Directory..."
				for i in $(seq 1 $cont)
				do
					mk=$(echo ${list[$path]} | tr '[/]' '_')
					mkdir /mnt/$mk
					mount -t nfs $ip:${list[$path]} /mnt/$mk -o nolock
					path=$((path+1))
					if [ "$path" = "$cont" ]; then
						echo "Load finished.."
						echo "Opening Path /mnt..."
						sleep 3
						gnome-terminal --working-directory=/mnt
						echo
					fi
				done
			else
				for i in $(seq 1 $cont)
				do
					echo "sudo mount -t nfs $ip:${list[$path]} /mnt -o nolock"
					path=$((path+1))
				done
			fi
		else
			echo
			echo -e "\e[91mTHERE ISN'T TO SHOW :("
		fi
	else
		echo
		echo -e "\e[92mUsage: bash script.sh ip"
		echo -e "\e[92mExample: bash script.sh 212.118.127.132"
		exit;
	fi
else
	echo ""
	echo -e "\e[91mYOU MUST HAVE ROOT PRIVILEGE :/"
	echo ""
	exit;
fi
