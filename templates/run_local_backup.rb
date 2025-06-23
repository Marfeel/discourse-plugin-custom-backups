#!/usr/bin/env ruby

require 'fileutils'
require File.expand_path("../config/environment", __dir__)
require_relative "../plugins/discourse-plugin-custom-backups/lib/custom_backup/local_backuper"
require_relative "../plugins/discourse-plugin-custom-backups/lib/custom_backup/s3_uploader"

# ==== Configuration: paths and environment ====

# Source path for the generated backup
source_dir = Rails.root.join("public", "backups", "default").to_s

# Destination path defined in the plugin settings
plugin_setting = SiteSetting.discourse_plugin_custom_backups_dest_dir
dest_dir = Rails.root.join(plugin_setting).to_s

# Create destination directory if it doesn't exist
FileUtils.mkdir_p(dest_dir)

# ==== Start backup process ====

user = Discourse.system_user
puts "[INFO] Starting local backup as #{user.username}..."

backup = CustomBackup::LocalBackuper.new(user.id, with_uploads: true)
filename = backup.run

# ==== Verify and move the backup file ====

if backup.success && filename
  source_file = File.join(source_dir, filename)
  dest_file   = File.join(dest_dir, filename)

  if File.exist?(source_file)
    FileUtils.mv(source_file, dest_file)
    puts "[SUCCESS] Backup completed successfully: #{dest_file}"
  else
    puts "[ERROR] Backup file not found: #{source_file}"
  end

  # ==== Upload to S3 if enabled ====
  if SiteSetting.discourse_plugin_custom_backups_s3_enable
    CustomBackup::S3Uploader.upload(dest_file)
  end

else
  puts "[ERROR] Backup failed or did not return a filename."
end