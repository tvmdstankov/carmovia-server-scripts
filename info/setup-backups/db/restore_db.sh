#!/bin/bash

# ----------------------------------
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not exist"
    exit 1
fi

# ----------------------------------
if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ]; then
    echo "Error: Missing DB_USER or DB_PASS in .env file."
    exit 1
fi

# ----------------------------------
if [ $# -ne 2 ]; then
   echo "Parametars: $0 <mode> <date>"
    exit 1
fi

# ----------------------------------
mode=$1
restore_date=$2

# ----------------------------------
backup_dir="./backup_dbs"

# ----------------------------------
backup_file="${mode}_${restore_date}.sql.gz"
db_name="${mode}_db"

# ----------------------------------
if [ ! -f "${backup_dir}/${backup_file}" ]; then
    echo "Error: The file ${backup_dir}/${backup_file} not exist."
    exit 1
fi

# ----------------------------------
gunzip -c "${backup_dir}/${backup_file}" | mysql -u "$DB_USER" -p"$DB_PASS" "$db_name"

# ----------------------------------
echo "Restore completed: ${db_name}"