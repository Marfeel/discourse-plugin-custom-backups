# name: discourse-plugin-custom-backups
# about: Create custom backup file
# version: 0.1
# authors: Marfeel

after_initialize do
  # API Reference
  require_relative "lib/controllers/backup_controller"
  require_relative "lib/routes/discourse_plugin_custom_backups_routes"
  DBackupRoutes.load
  # Define paths
  script_source = File.expand_path("../templates/run_local_backup.rb", __FILE__)
  script_target = Rails.root.join("script", "run_local_backup.rb")

  # Ensure target directory exists
  FileUtils.mkdir_p(File.dirname(script_target))

  # Copy and make the script executable
  FileUtils.cp(script_source, script_target)
  FileUtils.chmod("+x", script_target)

  # Log success
  Rails.logger.info "[discourse-plugin-custom-backups] Script installed at: #{script_target}"

  # Load the scheduled job
  load File.expand_path("../lib/jobs/daily/discourse_plugin_custom_backups_job.rb", __FILE__)
end