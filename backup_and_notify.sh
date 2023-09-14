#!/bin/bash

# Get the absolute path of the directory where the script is running
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from the .env file
if [ -f "$script_dir/.env" ]; then
  export $(cat "$script_dir/.env" | xargs)
fi

# Get the current date in YMD format (year, month, day)
current_date=$(date +"%Y%m%d")

# SendGrid credentials configuration
api_key="$SENDGRID_API_KEY"
from_email="backups_$current_date@$ENDPOINT"
to_email="$TO_EMAIL"
subject="Backup Database"

# Backup file name
backupFileName="backup_$current_date.sql.gz"

# Daily backups directory
backupDirectory="$script_dir/backups_daily"

# Create the daily backups directory if it doesn't exist
mkdir -p "$backupDirectory"

# Get the current year and month
current_year=$(date +"%Y")
current_month=$(date +"%m")

# Create the year directory if it doesn't exist
year_directory="$backupDirectory/$current_year"
mkdir -p "$year_directory"

# Create the month directory if it doesn't exist
month_directory="$year_directory/$current_month"
mkdir -p "$month_directory"

# Perform the database backup and compress it
mysqldump --no-tablespaces -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE_EXPORT" | gzip > "$month_directory/$backupFileName"

# Name the database with the current date for testing
database_name_test="$BACKUP_TEST"

# Decompress the backup file and change its name
uncompressedFileName="$month_directory/backup.sql.test"
gunzip -c "$month_directory/$backupFileName" > "$uncompressedFileName"

# Restore the database
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$database_name_test" < "$uncompressedFileName"

# Verify that the structure of the restored database is the same as "$MYSQL_DATABASE_EXPORT"
diff_output=$(mysqldiff --user="$MYSQL_USER" --password
