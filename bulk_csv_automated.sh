#!/bin/bash

##Script for searching servers from bulk.csv and adding them to .csv for processing AMD

#Find servers from the list file and createa new .csv for AMD processing

#Author : karthick,kb@kyndryl.com

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
	grep ${line} ${file1} >> ${ACCOUNT}_bulk_AMD.csv
	echo "found match server ${line}"
done < ${file2} 
}

automated ()
{
	bulk_servers
	echo "Do you want to Add/Modify/Delete server ? "
	read -p "Please enter 1 (add) , 2 (modify) , 3 (Delete) : " selection
	if [[ ${selection} -eq 1 ]]
	then 
	grep -v "#A/M/D" ${ACCOUNT}_bulk_AMD.csv |awk -F "," '{gsub("M","A",$1)}1' > ${ACCOUNT}_customized.csv
	sed -i 's/ /,/g' ${ACCOUNT}_customized.csv
        grep Display ${file1} > ${ACCOUNT}_template.csv
        cat ${ACCOUNT}_customized.csv >> ${ACCOUNT}_template.csv
	elif [[ ${selection} -eq 3 ]]
	then
	cat ${ACCOUNT}_bulk_AMD.csv |awk -F "," '{gsub("M","D",$1)}1' > ${ACCOUNT}_customized.csv
	sed -i 's/ /,/g' ${ACCOUNT}_customized.csv
	grep Display ${file1} > ${ACCOUNT}_template.csv
	cat ${ACCOUNT}_customized.csv >> ${ACCOUNT}_template.csv
	elif [[ ${selection} -eq 2 ]]
	then
	grep Display ${file1} > ${ACCOUNT}_template.csv
	cat ${ACCOUNT}_bulk_AMD.csv >> ${ACCOUNT}_template.csv
	else
	echo "Invalid option: Please enter a valid option 1 or 2 or 3 "
	exit 1

fi
}

menu ()
{
#create a menu for users
echo
echo
echo -e "	\tMENU for bulk AMD"
echo -e "	\t================="
echo -e "	\t1.Generate a .csv file for required server list "
echo -e "	\t2.Generating Automated AMD .csv for gg_run_csv "
echo -e "	\t3.Exit "

#read -p "Enter your choice : " CHOICE
}

files ()
{
	read -p "Enter your .csv file: " file1
	if [[ ! -f $file1 ]]
	then
		echo "Please enter a valid .csv file.."
		echo "Press enter for main menu"
		read RESPONSE
		logic
	fi
	read -p "Enter the server list .txt file: " file2
	if [[ ! -f $file2 ]]
	then
		echo "please enter a valid .txt file.."
		read RESPONSE
		logic
	fi
}

logic ()
{
while true
do
menu
echo "Enter your choice: "
read CHOICE
if [[ ${CHOICE} -eq 1 ]]
	then
	files
	account
	grep Display slde_bulk.csv > ${ACCOUNT}_bulk_AMD.csv
	bulk_servers
	echo "Script bulk completed successfully find your ${ACCOUNT}_bulk_AMD.csv file in the same directory"
	elif [[ ${CHOICE} -eq 2 ]]
	then
	files
	account
	automated
	echo "Automatic script completed successfully find your ${ACCOUNT}_template.csv"
	elif [[ ${CHOICE} -eq 3 ]]
	then
	exit 0
	else
	echo "Enter options 1, 2 or 3 "
fi
done
}
logic
