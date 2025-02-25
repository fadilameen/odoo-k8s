#!/bin/bash

# Variables

CONTAINER_ID="odoo-docker-setup_odoo_main_1"

DB_CONTAINER_ID="odoo-docker-setup_db-main_1"

HOST_PATH="/home/cybrosys/odoo-docker-setup/backup"

CONTAINER_PATH="/tmp"
if docker ps -a --format '{{.Names}}' | grep -q "^odoo-docker-setup_odoo_main_1$"; then


        FILESTORE_BACKUP_NAME="odoo_filestore_backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
        # FILESTORE_BACKUP_NAME="odoo_filestore_backup"


        DB_BACKUP_NAME="odoo_db_backup_`date +%Y-%m-%d"_"%H_%M_%S`.sql"


        # Database Backup

        docker exec -t $DB_CONTAINER_ID pg_dumpall -c -U odoo18-main > $HOST_PATH/$DB_BACKUP_NAME

        if [ -f "$HOST_PATH/$DB_BACKUP_NAME" ]; then
            echo "[INFO] ======= Database backup complete =======" 
        fi

        # Filestore Backup


        docker exec $CONTAINER_ID tar -cvzf $CONTAINER_PATH/$FILESTORE_BACKUP_NAME -C /var/lib odoo
        # sudo docker exec --user root $CONTAINER_ID tar -cvzf /odoo_backup_test_2.tar.gz -C /var/lib odoo
        if [ -f "$CONTAINER_PATH/$FILESTORE_BACKUP_NAME" ]; then
            echo "[INFO] ======= Filestore backed up inside container =======" 
        fi


        docker cp $CONTAINER_ID:$CONTAINER_PATH/$FILESTORE_BACKUP_NAME $HOST_PATH
        # sudo docker cp $CONTAINER_ID:odoo_backup_test_2.tar.gz $HOST_PATH

        if [ -f "$HOST_PATH/$FILESTORE_BACKUP_NAME" ]; then
            echo "[INFO] ======= Filestore backup moved to external storage ----------" 
            echo "[SUCCESS] ***** Filestore backup complete *****"
        fi

        # docker exec $CONTAINER_ID sh -c "ls -tp /tmp/*.tar.gz | grep -v '/$' | tail -n +8 | xargs rm --"
        docker exec $CONTAINER_ID sh -c "find /tmp -type f -name '*.tar.gz' -mtime +7 -exec rm -- {} \;"



        ls -tp "$HOST_PATH"/*.tar.gz | grep -v '/$' | tail -n +8 | xargs rm --
        ls -tp "$HOST_PATH"/*.sql | grep -v '/$' | tail -n +8 | xargs rm --



        # Optional: Remove old backups, keeping last 3

        # find $HOST_PATH -type f -name '*.tar.gz' -mtime +3 -exec rm {} \\\\;

        # find $HOST_PATH -type f -name '*.sql' -mtime +3 -exec rm {} \\\\;


        if [ -f "$HOST_PATH/$DB_BACKUP_NAME" ] && [ -f "$HOST_PATH/$FILESTORE_BACKUP_NAME" ]; then
            echo "[SUCCESS] ===================== Backup completed successfully ====================="  
        fi

else
    echo "Container does not exist."
fi
ls -tp /home/cybrosys/odoo-docker-setup/backup/backup_*.log | grep -v '/$' | tail -n +8 | xargs rm --


