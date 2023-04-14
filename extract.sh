#!/bin/bash
output_list=./list.md
last_id_ref=./.last_id
without_tag=0
if [ ! -f $last_id_ref ]; then 
	id=0
	rm $output_list
	touch $output_list
else
	id=$(($(cat $last_id_ref) + 1))
fi
#id=8
while [ true ]
do
	title=$(curl -s  https://crazyshit.com/memes/tag/${id}-cringe/ | grep "<title>" | sed -e 's/<[^>]*>//g')
	separator=$(echo $title | awk '{print $2}')
	if [ $separator == "|" ]; then
		tag=$(echo $title | sed 's/ - Crazy Shit//g' | awk '{print $2}' FS='[|]' | awk '{$(NF--)=""; print $0}' | sed 's/ *$//g' |  tr " " "-")
		echo "${id}-${tag} : https://crazyshit.com/memes/tag/${id}-${tag}/"
		echo "[${tag}](https://crazyshit.com/memes/tag/${id}-${tag}/)  " >> $output_list
		without_tag=0
		echo $id > $last_id_ref
	else
		echo "$id : not found"
		without_tag=$((without_tag + 1))
	fi
	if [ $without_tag -eq 100 ]; then
		break
	fi
	id=$((id + 1))
#	exit
done
echo "End of process"
