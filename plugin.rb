# name: d-backup
# about: Create custom backup file
# version: 0.1
# authors: Marfeel

after_initialize do
  script_target_path = Rails.root.join("script", "run_local_backup.rb")
  script_source_path = File.expand_path("../templates/run_local_backup.rb", __FILE__)

  FileUtils.mkdir_p(File.dirname(script_target_path))
  FileUtils.cp(script_source_path, script_target_path)
  FileUtils.chmod("+x", script_target_path)
  Rails.logger.info "[d-backup] Copied run_local_backup.rb to #{script_target_path}"

  load File.expand_path("../lib/jobs/daily/d_backup_job.rb", __FILE__)
end
