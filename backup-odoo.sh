#!/bin/bash

DB_VOLUME="odoo-docker-setup_db-main"
ODOO_VOLUME="odoo-docker-setup_data-main"
HOST_PATH="/home/cybrosys/odoo-docker-setup/backup"

mkdir -p "$HOST_PATH"

# Database Backup
DB_BACKUP_NAME="odoo_db_backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

echo "[INFO] Starting database backup..." 
docker run --rm -v "$DB_VOLUME:/data" -v "$HOST_PATH:/backup" busybox sh -c "tar czf /backup/$DB_BACKUP_NAME /data"
if [ -f "$HOST_PATH/$DB_BACKUP_NAME" ]; then
    echo "[SUCCESS] Database backup completed: $DB_BACKUP_NAME" 
else
    echo "[ERROR] Database backup failed!" 
fi

# Filestore Backup
FILESTORE_BACKUP_NAME="odoo_filestore_backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

echo "[INFO] Starting filestore backup..." 
docker run --rm -v "$ODOO_VOLUME:/data" -v "$HOST_PATH:/backup" busybox sh -c "tar czf /backup/$FILESTORE_BACKUP_NAME /data"
if [ -f "$HOST_PATH/$FILESTORE_BACKUP_NAME" ]; then
    echo "[SUCCESS] Filestore backup completed: $FILESTORE_BACKUP_NAME" 
else
    echo "[ERROR] Filestore backup failed!" 
fi

echo "[INFO] Cleaning up old backups..." 
ls -tp "$HOST_PATH"/*.tar.gz | grep -v '/$' | tail -n +8 | xargs rm -- 2>/dev/null
echo "[INFO] Old backups cleaned up." 

ls -tp /home/cybrosys/odoo-docker-setup/backup/backup_*.log | grep -v '/$' | tail -n +8 | xargs rm --
echo "[INFO] Old log files cleaned up." 

echo "[SUCCESS] ===================== Backup process completed successfully =====================" 
