#!/bin/bash

##Script for searching servers from bulk.csv and adding them to .csv for processing AMD

#Find servers from the list file and createa new .csv for AMD processing

#create functions for the script

echo "working with file ${1}"
sleep 3
echo "Generating file for servers in ${2}"
sleep 3
check ()
{
	if [[ $? -ne 0 ]] 
	then 
	echo "There is an error in the script"
	exit 1
fi
}

account ()
{
	read -p "Please enter the account name : " ACCOUNT
}

bulk_servers ()
{
while read line 
do 
	grep ${line} ${1} >> ${ACCOUNT}_bulk_AMD.csv
	echo "found match server ${line}"
done < ${2}
check 
}

automated ()
{
	bulk_servers ${1} ${2}
	echo "Do you want to Add/Modify/Delete server ? "
	read -p "Please enter A (add) , M (modify) , D (Delete) : " selection
	if [[ ${selection} -eq A ]]
	then 
	grep -v "#A/M/D" ${ACCOUNT}_bulk_AMD.csv |awk -F "," '{gsub("M","A",$1)}1' > ${ACCOUNT}_customized.csv
	sed -i 's/ /,/g' ${ACCOUNT}_customized.csv
        grep Display ${1} > ${ACCOUNT}_template.csv
        cat ${ACCOUNT}_customized.csv >> ${ACCOUNT}_template.csv
	elif [[ ${selection} -eq D ]]
	then
	cat ${ACCOUNT}_bulk_AMD.csv |awk -F "," '{gsub("M","D",$1)}1' > ${ACCOUNT}_customized.csv
	sed -i 's/ /,/g' ${ACCOUNT}_customized.csv
	grep Display ${1} > ${ACCOUNT}_template.csv
	cat ${ACCOUNT}_customized.csv >> ${ACCOUNT}_template.csv
	elif [[ ${selection} -eq M ]]
	then
	cat ${ACCOUNT}_bulk_AMD.csv > ${ACCOUNT}_template.csv
	else
	echo "Invalid option: Please enter a valid option A/M/D "
	exit 1

fi
check
}

menu ()
{
#create a menu for users
echo
echo
echo "	MENU for bulk AMD"
echo "	================="
echo "	1.Bulk server .csv generator "
echo "	2.Fully automated gg_csv_run "
echo "	3.Exit "

read -p "Enter your choice : " CHOICE
}

while true
do
menu
if [[ ${CHOICE} -eq 1 ]]
	then
	account
	grep Display slde_bulk.csv > ${ACCOUNT}_bulk_AMD.csv
	bulk_servers ${1} ${2}
	echo "Script bulk completed successfully find your ${ACCOUNT}_bulk_AMD.csv file in the same directory"
	elif [[ ${CHOICE} -eq 2 ]]
	then
	account
	automated ${1} ${2}
	echo "Automatic script completed successfully find your ${ACCOUNT}_template.csv"
	elif [[ ${CHOICE} -eq 3 ]]
	then
	exit 0
	else
	echo "Enter options 1, 2 or 3 "
	exit 0
fi
check
done
