module CustomBackup
    class LocalBackuper < BackupRestore::Backuper
      def upload_archive
        log "Skipping upload to remote store (S3 or other)"
      end

      def delete_uploaded_archive
        log "Custom clean_up: nothing to do"
      end

      def clean_up
        log "Cleaning"
        remove_tar_leftovers
        mark_backup_as_not_running
        refresh_disk_space if success
      end
    end
  end