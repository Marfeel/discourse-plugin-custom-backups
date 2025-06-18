# name: d-backup
# about: Create custom backup file
# version: 0.1
# authors: Marfeel

after_initialize do
  # Define paths
  script_source = File.expand_path("../templates/run_local_backup.rb", __FILE__)
  script_target = Rails.root.join("script", "run_local_backup.rb")

  # Ensure target directory exists
  FileUtils.mkdir_p(File.dirname(script_target))

  # Copy and make the script executable
  FileUtils.cp(script_source, script_target)
  FileUtils.chmod("+x", script_target)

  # Log success
  Rails.logger.info "[d-backup] Script installed at: #{script_target}"

  # Load the scheduled job
  require_relative "../lib/jobs/daily/d_backup_job"
end