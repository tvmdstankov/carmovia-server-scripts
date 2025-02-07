#!/bin/bash

# ----------------------------------
script_dir=$(dirname "$0")
script_dir=$(cd "$script_dir" && pwd)
echo "script_dir: $script_dir"


# ----------------------------------
if [ -f "$script_dir/.env" ]; then
    source "$script_dir/.env"
else
    echo "Error: "$script_dir/.env" file not exist"
    exit 1
fi

if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ]; then
    echo "Error: Missing DB_USER or DB_PASS in "$script_dir/.env" file."
    exit 1
fi

# ----------------------------------
if [ $# -ne 1 ]; then
    echo "Parametars: $0 <mode>"
    exit 1
fi
mode=$1

# ----------------------------------
backup_dir="$script_dir/backup_dbs"
mkdir -p "$backup_dir"

# ----------------------------------
find "$backup_dir" -type f -name "${mode}_*.sql.gz" -mtime +5 -delete

# ----------------------------------
db_name="${mode}_db"
backup_file="${mode}_$(date +%Y%m%d).sql.gz"

# ----------------------------------
mysqldump -u "$DB_USER" -p"$DB_PASS" "$db_name" | gzip > "${backup_dir}/${backup_file}"

# ----------------------------------
echo "Bakup created: ${backup_dir}/${backup_file}"