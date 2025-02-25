# DB backup
# docker run --rm -v "odoo-docker-setup_db-main:/data" -v "/home/cybrosys/odoo-docker-setup/backup:/backup" busybox sh -c "tar czf /backup/odoo_db_backup_2025-02-21_08-49-37.tar.gz /data"

# DB restore
docker run --rm -v "odoo-docker-setup_db-staging:/data" -v "/home/cybrosys/odoo-docker-setup/backup:/backup" busybox sh -c "tar xzf /backup/odoo_db_backup_2025-02-21_08-49-37.tar.gz -C /"

# Filestore backup
# docker run --rm -v "odoo-docker-setup_data-main:/data" -v "/home/cybrosys/odoo-docker-setup/backup:/backup" busybox sh -c "tar czf /backup/odoo_filestore_backup_2025-02-21_08-49-40.tar.gz /data"

# Filestore restore
docker run --rm -v "odoo-docker-setup_data-staging:/data" -v "/home/cybrosys/odoo-docker-setup/backup:/backup" busybox sh -c "tar xzf /backup/odoo_filestore_backup_2025-02-21_08-49-40.tar.gz -C /"
